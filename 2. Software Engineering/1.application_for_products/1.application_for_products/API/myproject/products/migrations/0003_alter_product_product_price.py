# Generated by Django 4.2.5 on 2023-09-26 13:30

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        (
            "products",
            "0002_alter_product_product_id_alter_product_product_price_and_more",
        ),
    ]

    operations = [
        migrations.AlterField(
            model_name="product",
            name="product_price",
            field=models.DecimalField(decimal_places=1, max_digits=10),
        ),
    ]