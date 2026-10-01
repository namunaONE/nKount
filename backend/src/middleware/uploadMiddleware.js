/**
 * Upload Middleware
 * Handles file uploads for images and documents
 */

const multer = require('multer');
const path = require('path');
const fs = require('fs');
const config = require('../config/env');
const { createLogger } = require('winston');

const logger = createLogger({
  level: config.logging.level,
  format: createLogger.format.combine(
    createLogger.format.timestamp(),
    createLogger.format.json()
  ),
  transports: [
    new createLogger.transports.Console(),
    new createLogger.transports.File({ filename: 'logs/upload.log' })
  ]
});

// Ensure upload directories exist
const ensureDirectories = () => {
  const directories = [
    config.upload.tempDir,
    config.upload.permanentDir,
    path.join(config.upload.permanentDir, 'images'),
    path.join(config.upload.permanentDir, 'documents'),
    path.join(config.upload.permanentDir, 'logs'),
  ];
  
  directories.forEach(dir => {
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
      logger.info(`Created directory: ${dir}`);
    }
  });
};

// Initialize directories
ensureDirectories();

// File filter for image uploads
const imageFileFilter = (req, file, cb) => {
  const allowedTypes = config.upload.allowedTypes || ['image/jpeg', 'image/png', 'image/webp'];
  
  if (allowedTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new Error(`Invalid file type. Allowed types: ${allowedTypes.join(', ')}`), false);
  }
};

// File filter for document uploads
const documentFileFilter = (req, file, cb) => {
  const allowedTypes = ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'];
  
  if (allowedTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new Error(`Invalid file type. Allowed types: ${allowedTypes.join(', ')}`), false);
  }
};

// File filter for any allowed type
const generalFileFilter = (req, file, cb) => {
  const allowedTypes = config.upload.allowedTypes || [];
  
  if (allowedTypes.length === 0 || allowedTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new Error(`Invalid file type. Allowed types: ${allowedTypes.join(', ')}`), false);
  }
};

// Storage configuration for temporary uploads
const tempStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, config.upload.tempDir);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    const ext = path.extname(file.originalname);
    const basename = path.basename(file.originalname, ext);
    cb(null, `${basename}-${uniqueSuffix}${ext}`);
  },
});

// Storage configuration for permanent uploads
const permanentStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadDir = req.uploadDir || config.upload.permanentDir;
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    const ext = path.extname(file.originalname);
    const basename = path.basename(file.originalname, ext);
    cb(null, `${basename}-${uniqueSuffix}${ext}`);
  },
});

// Multer instances
const uploadTemp = multer({
  storage: tempStorage,
  fileFilter: generalFileFilter,
  limits: {
    fileSize: config.upload.maxFileSize,
  },
});

const uploadPermanent = multer({
  storage: permanentStorage,
  fileFilter: generalFileFilter,
  limits: {
    fileSize: config.upload.maxFileSize,
  },
});

const uploadImage = multer({
  storage: permanentStorage,
  fileFilter: imageFileFilter,
  limits: {
    fileSize: config.upload.maxFileSize,
  },
});

const uploadDocument = multer({
  storage: permanentStorage,
  fileFilter: documentFileFilter,
  limits: {
    fileSize: config.upload.maxFileSize,
  },
});

// Middleware to set upload directory based on entity type
const setUploadDir = (entityType) => {
  return (req, res, next) => {
    const uploadDirs = {
      company: path.join(config.upload.permanentDir, 'companies'),
      contact: path.join(config.upload.permanentDir, 'contacts'),
      product: path.join(config.upload.permanentDir, 'products'),
      transaction: path.join(config.upload.permanentDir, 'transactions'),
      payment: path.join(config.upload.permanentDir, 'payments'),
    };
    
    req.uploadDir = uploadDirs[entityType] || config.upload.permanentDir;
    
    // Ensure directory exists
    if (!fs.existsSync(req.uploadDir)) {
      fs.mkdirSync(req.uploadDir, { recursive: true });
    }
    
    next();
  };
};

// File cleanup middleware
const cleanupTempFiles = (req, res, next) => {
  // Store original send function
  const originalSend = res.send;
  
  res.send = function(body) {
    // Clean up temp files after response is sent
    res.on('finish', () => {
      if (req.files) {
        req.files.forEach(file => {
          try {
            if (file.path.startsWith(config.upload.tempDir)) {
              fs.unlinkSync(file.path);
              logger.info(`Cleaned up temp file: ${file.path}`);
            }
          } catch (error) {
            logger.error(`Error cleaning up temp file: ${error.message}`);
          }
        });
      }
      
      if (req.file && req.file.path.startsWith(config.upload.tempDir)) {
        try {
          fs.unlinkSync(req.file.path);
          logger.info(`Cleaned up temp file: ${req.file.path}`);
        } catch (error) {
          logger.error(`Error cleaning up temp file: ${error.message}`);
        }
      }
    });
    
    originalSend.call(this, body);
  };
  
  next();
};

// Error handler for multer
const handleMulterError = (err, req, res, next) => {
  if (err.code === 'LIMIT_FILE_SIZE') {
    return res.badRequest({
      error: 'File too large',
      code: 'FILE_TOO_LARGE',
      message: `File size exceeds maximum limit of ${config.upload.maxFileSize / (1024 * 1024)}MB`,
    });
  }
  
  if (err.code === 'LIMIT_UNEXPECTED_FILE') {
    return res.badRequest({
      error: 'Unexpected file',
      code: 'UNEXPECTED_FILE',
      message: 'An unexpected file was uploaded',
    });
  }
  
  if (err.message.includes('Invalid file type')) {
    return res.badRequest({
      error: 'Invalid file type',
      code: 'INVALID_FILE_TYPE',
      message: err.message,
    });
  }
  
  next(err);
};

// Middleware to check if file exists
const checkFileExists = (fieldName = 'file') => {
  return (req, res, next) => {
    if (!req.files || !req.files[fieldName]) {
      return res.badRequest({
        error: 'No file uploaded',
        code: 'NO_FILE_UPLOADED',
      });
    }
    next();
  };
};

// Middleware to move file from temp to permanent
const moveFileToPermanent = (fieldName = 'file', targetDir) => {
  return async (req, res, next) => {
    try {
      const file = req.files?.[fieldName] || req.file;
      
      if (!file) {
        return next();
      }
      
      if (!file.path.startsWith(config.upload.tempDir)) {
        return next();
      }
      
      const targetPath = path.join(targetDir || config.upload.permanentDir, path.basename(file.path));
      
      // Ensure target directory exists
      if (!fs.existsSync(targetDir || config.upload.permanentDir)) {
        fs.mkdirSync(targetDir || config.upload.permanentDir, { recursive: true });
      }
      
      // Move file
      fs.renameSync(file.path, targetPath);
      
      // Update file path in request
      if (req.files?.[fieldName]) {
        req.files[fieldName].path = targetPath;
      } else if (req.file) {
        req.file.path = targetPath;
      }
      
      logger.info(`Moved file from temp to permanent: ${targetPath}`);
      
      next();
    } catch (error) {
      logger.error(`Error moving file to permanent: ${error.message}`);
      next(error);
    }
  };
};

module.exports = {
  upload: uploadPermanent,
  uploadTemp,
  uploadImage,
  uploadDocument,
  setUploadDir,
  cleanupTempFiles,
  handleMulterError,
  checkFileExists,
  moveFileToPermanent,
  imageFileFilter,
  documentFileFilter,
  generalFileFilter,
};
