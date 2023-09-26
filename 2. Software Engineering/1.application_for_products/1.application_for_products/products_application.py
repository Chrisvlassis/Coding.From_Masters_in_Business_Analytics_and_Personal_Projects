# Import what you need from tkinter module
from tkinter import Tk, Button, PhotoImage, Label, LabelFrame, W, E,N,S, Entry, END,StringVar ,Scrollbar,Toplevel, messagebox
from tkinter import ttk   # Provides access to the Tk themed widgets.
import sqlite3
import os



class Contacts:
    
    dir_path = os.path.dirname(os.path.abspath(__file__))
    db_filename = os.path.join(dir_path, "data", "Products.db")
    
    def __init__(self,root):
        self.root = root
        self.photo_path = os.path.join(Contacts.dir_path, "resources", "logo_ERP.gif")
        self.create_gui()
        ttk.style = ttk.Style()
        ttk.style.configure("Treeview", font=('helvetica',10))
        ttk.style.configure("Treeview.Heading", font=('helvetica',12, 'bold'))

#--------------------------------- GUI functions --------------------------------#

# function only for the gui
    def create_gui(self):
        self.create_left_icon()
        self.create_label_frame()
        self.create_message_area()
        self.create_tree_view()
        self.create_scrollbar()
        self.create_bottom_buttons()
        self.populate_tree_view()


# create the icon:
    def create_left_icon(self):
        photo = PhotoImage(file=self.photo_path)
        label = Label(image=photo)
        label.image = photo
        label.grid(row=0, column=0)
        
# create the label frame
    def create_label_frame(self):
        labelframe = LabelFrame(self.root, text='Add Product',bg="sky blue",font="helvetica 10")
        labelframe.grid(row=0, column=1, padx=8, pady=8, sticky='ew')
        Label(labelframe, text='Product ID:',bg="green",fg="white").grid(row=1, column=1, sticky=W, pady=2,padx=15)
        self.id = Entry(labelframe)
        self.id.grid(row=1, column=2, sticky=W, padx=5, pady=2)
        Label(labelframe, text='Product Name:',bg="brown",fg="white").grid(row=2, column=1, sticky=W,  pady=2,padx=15)
        self.name = Entry(labelframe)
        self.name.grid(row=2, column=2, sticky=W, padx=5, pady=2)
        Label(labelframe, text='Product Price:',bg="black",fg="white").grid(row=3, column=1, sticky=W,  pady=2,padx=15)
        self.price = Entry(labelframe)
        self.price.grid(row=3, column=2, sticky=W, padx=5, pady=2)
        Button(labelframe, text='Add Product', command=self.add_product,bg="blue",fg="white").grid(row=4, column=2, sticky=E, padx=5, pady=5)

# create the message area
    def create_message_area(self):
        self.message = Label(text='', fg='red')
        self.message.grid(row=3, column=1, sticky=W)
        
# create the tree view
    def create_tree_view(self):
        self.tree = ttk.Treeview(height=10, columns=("Product_Name","Product_Price"),style='Treeview')
        self.tree.grid(row=6, column=0, columnspan=3)
        self.tree.heading('#0', text='Product ID', anchor=W)
        self.tree.heading("Product_Name", text='Product Name', anchor=W)
        self.tree.heading("Product_Price", text='Product Price', anchor=W)
        
# create the scrollbar
    def create_scrollbar(self):
        self.scrollbar = Scrollbar(orient='vertical',command=self.tree.yview)
        self.scrollbar.grid(row=6,column=3,rowspan=10,sticky='sn')

# create the bottom buttons
    def create_bottom_buttons(self):
        Button(text='Delete Selected', command=self.delete_selected_product,bg="red",fg="white").grid(row=8, column=0, sticky=W,pady=10,padx=20)


#-------------------------------------------------------------------------#




#------------------------ DATABASE & INTERACTION FUNCTIONS -----------------------------#

    # SELECT * FROM Product_Data
    def display_records(self):
        # Connect to the database
        with sqlite3.connect(self.db_filename) as conn:
            cursor = conn.cursor()
            
            # Execute the SELECT query
            cursor.execute('SELECT * FROM Product_Data')
            
            # Fetch all the results
            records = cursor.fetchall()
            return records


    # populate the tree view 
    def populate_tree_view(self):
        # Remove any existing rows in the treeview
        for row in self.tree.get_children():
            self.tree.delete(row)
        
        # Fetch records and add to tree view
        records = self.display_records()
        for record in records:
            self.tree.insert('', 'end', text=record[0], values=(record[1], record[2]))



# add product to database
    def add_product_to_db(self, product_id, product_name, product_price):
    # Connect to the database
        with sqlite3.connect(self.db_filename) as conn:
            cursor = conn.cursor()
    
            # Execute the INSERT query
            cursor.execute('INSERT INTO Product_Data (Product_id, Product_name, Product_price) VALUES (?, ?, ?)', 
                           (product_id, product_name, product_price))
    
            # Commit the changes
            conn.commit()
            
            

# retrive entry fields and add them to database:
    def add_product(self):
        # Retrieve values from the Entry fields
        product_id = self.id.get()
        product_name = self.name.get()
        product_price = self.price.get()
    
        # Insert the product into the database
        self.add_product_to_db(product_id, product_name, product_price)
    
        # Add the product to the tree view
        self.tree.insert('', 'end', text=product_id, values=(product_name, product_price))
    
        # Optionally clear the Entry fields after insertion
        self.id.delete(0, END)
        self.name.delete(0, END)
        self.price.delete(0, END)
    
        # Optionally show a message saying the product was added
        self.message['text'] = f'Product {product_name} added successfully!'



# function for deleting the contact
    def delete_selected_product(self):
        try:
            # Retrieve the selected item from the tree view
            selected_item = self.tree.selection()[0]  # Get the item's ID
            product_id = self.tree.item(selected_item, 'text')  # Get the product ID from the item
            
            # Confirm if the user really wants to delete the selected product
            confirm = messagebox.askyesno("Confirmation", f"Are you sure you want to delete Product ID {product_id}?")
            if confirm:
                # Connect to the database and delete the product
                with sqlite3.connect(self.db_filename) as conn:
                    cursor = conn.cursor()
                    cursor.execute('DELETE FROM Product_Data WHERE Product_id = ?', (product_id,))
                    conn.commit()
    
                # Remove the item from the tree view
                self.tree.delete(selected_item)
                
                # Display a message saying the product was deleted
                self.message['text'] = f'Product with ID {product_id} deleted successfully!'
            else:
                self.message['text'] = 'Product deletion cancelled.'
    
        except IndexError:  # No item is selected
            self.message['text'] = 'Please select a product to delete!'




if __name__ == '__main__':
    root =Tk()
    root.title('Insert Products')
    root.geometry("650x450")
    root.resizable(width=False, height=False)
    application = Contacts(root)
    root.mainloop()
    
    
    
    
    
    
