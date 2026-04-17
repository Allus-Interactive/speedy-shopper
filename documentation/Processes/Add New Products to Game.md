### How to add new products into the game to be populated on shelves.
- Step 1 - Create a new `Item` resource in the correct `{resource_type}` folder under **game** -> **resources** -> **item** -> **resources** -> **{resource_type}** 
	- Note: if adding a product of a new type, be sure to add the new type to the `CATEGORY` enum in `item.gd`
- Step 2 - Enter the relevant data into the resource by double clicking it in the file system window
	![[item resource panel.png]]
	Make sure to record the new barcode in the Barcodes file in this documentation
- Step 3 - Now create a new `Product` resource in the correct `{resource_type}` folder under **game** -> **resources** -> **product** -> **resources** -> **{resource_type}** 
	- Step 4 - Enter the relevant data into the resource by double clicking it in the file system window. Some data will be auto filled, the main things here are assigning the new `item`resource as the `Product Info` and updating the `Placeholder Size` and `Product Colour` to closely resemble the product you are creating
		- Note: The `y` value of the `Shelf Offset` should always be half of the `y` value of the `Placeholder Size`
	![[product resource panel.png]]
- Step 5 - Next, add the new `Product` resource onto a Shelf Unit (see Constructing Shelf Units) and add an instance of the `Item` resource into the `ProductManager`. Open `product_manager.tscn` and drag and drop the new `Item` resource into the `All Products` array 