/**
 * Product Routes
 * RESTful endpoints for product management
 */

const express = require('express');
const router = express.Router();
const productController = require('../controllers/productController');
const authMiddleware = require('../middleware/authMiddleware');
const validationMiddleware = require('../middleware/validationMiddleware');
const { validateProduct, validateProductUpdate } = require('../middleware/validators/productValidator');
const uploadMiddleware = require('../middleware/uploadMiddleware');

// Public routes
router.get('/', productController.getAllProducts);
router.get('/:id', productController.getProductById);

// Protected routes (require authentication)
router.use(authMiddleware.authenticate);

// Product routes
router.post('/', uploadMiddleware.upload.single('image'), validateProduct, productController.createProduct);
router.post('/bulk', productController.createProductsBulk);
router.put('/:id', uploadMiddleware.upload.single('image'), validateProductUpdate, productController.updateProduct);
router.patch('/:id', uploadMiddleware.upload.single('image'), validateProductUpdate, productController.updateProductPartial);
router.delete('/:id', productController.deleteProduct);
router.delete('/bulk', productController.deleteProductsBulk);

// Product categories
router.get('/categories', productController.getProductCategories);
router.get('/:id/category', productController.getProductCategory);

// Product brands
router.get('/brands', productController.getProductBrands);
router.get('/:id/brand', productController.getProductBrand);

// Product units
router.get('/units', productController.getProductUnits);
router.get('/:id/unit', productController.getProductUnit);

// Product stock
router.get('/:id/stock', productController.getProductStock);
router.post('/:id/stock/adjust', productController.adjustProductStock);
router.get('/stock/low', productController.getLowStockProducts);
router.get('/stock/out', productController.getOutOfStockProducts);

// Product pricing
router.get('/:id/pricing', productController.getProductPricing);
router.put('/:id/pricing', productController.updateProductPricing);

// Product statistics
router.get('/:id/stats', productController.getProductStats);
router.get('/stats/summary', productController.getProductSummaryStats);

// Product search
router.get('/search', productController.searchProducts);

// Product barcode
router.get('/barcode/:barcode', productController.getProductByBarcode);
router.get('/code/:code', productController.getProductByCode);

// Export products
router.get('/export/csv', productController.exportProductsCSV);
router.get('/export/excel', productController.exportProductsExcel);

// Import products
router.post('/import/csv', productController.importProductsCSV);
router.post('/import/excel', productController.importProductsExcel);

// Product images
router.post('/:id/image', uploadMiddleware.upload.single('image'), productController.uploadProductImage);
router.delete('/:id/image', productController.deleteProductImage);

module.exports = router;
