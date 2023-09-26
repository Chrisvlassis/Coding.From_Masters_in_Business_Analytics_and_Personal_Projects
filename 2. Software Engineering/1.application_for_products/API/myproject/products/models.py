from django.db import models

class Product(models.Model):
    product_id = models.CharField(max_length=255, primary_key=True)
    product_name = models.CharField(max_length=255)
    product_price = models.DecimalField(max_digits=10, decimal_places=1)
    
    class Meta:
        db_table = 'Product_Data'

