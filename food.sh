#!/bin/bash

# Admin and User Menu
echo "Welcome to the Food Ordering System!"
echo "Please choose an option:"
echo "1. Admin"
echo "2. User"
read role_choice

# Admin Section
if [ "$role_choice" -eq 1 ]; then
    echo "Admin login"
    echo "Please enter admin password:"
    read password

    # Admin password validation
    if [ "$password" == "admin123" ]; then
        echo "Login successful!"
        
        # Admin Menu
        while true; do
            echo "Admin Menu:"
            echo "1. Add new menu item"
            echo "2. View order history"
            echo "3. Delete menu item"
            echo "4. Exit"
            read admin_choice
            
            case $admin_choice in
                1)
                    # Add new menu item
                    echo "Enter food name:"
                    read food_name
                    echo "Enter sizes (comma separated):"
                    read sizes
                    echo "Enter prices (comma separated):"
                    read prices
                    
                    # Append the new item to the menu.txt file
                    echo "$food_name - $sizes - $prices" >> menu.txt
                    echo "New menu item added successfully!"
                    ;;
                2)
                    # View order history
                    if [ -f "order_history.txt" ]; then
                        echo "Order History:"
                        cat order_history.txt
                    else
                        echo "No order history found!"
                    fi
                    ;;
                3)
                    # Delete menu item
                    echo "Enter the item number to delete from the menu:"
                    read item_number
                    if [ -f "menu.txt" ]; then
                        sed -i "${item_number}d" menu.txt
                        echo "Menu item $item_number deleted successfully!"
                    else
                        echo "Menu file not found!"
                    fi
                    ;;
                4)
                    # Exit Admin Menu
                    echo "Exiting Admin Menu."
                    break
                    ;;
                *)
                    echo "Invalid option!"
                    ;;
            esac
        done
    else
        echo "Invalid password!"
        exit 1
    fi
fi

# User Section
echo "User login"
echo "Please enter your name:"
read name
echo "Login successful! Welcome, $name!"

# Predefined Menu for the first 8 items
echo "______MENU ITEM_____"
echo "____________________"
echo "| Item No | FOOD Name           | Size/Types                     | Price (Tk)              |"
echo "-------------------------------------------------------------------------------------------"
echo "| 1       | Chicken pot pie     | 6 inches / 8 inches / 10 inches / 12 inches  | 150 / 170 / 200 / 250   |"
echo "| 2       | Mashed potatoes     | 100g / 200g / 300g / 400g       | 100 / 120 / 150 / 200   |"
echo "| 3       | Fried chicken       | 150g / 200g / 250g              | 150 / 170 / 200         |"
echo "| 4       | Burgers             | Chicken / Egg / Vegetables      | 150 / 50 / 40           |"
echo "| 5       | Chicken soup        | 150g / 250g / 300g             | 70 / 120 / 150          |"
echo "| 6       | Coke                | 250mL / 500mL / 1L / 2L         | 30 / 50 / 80 / 120      |"
echo "| 7       | Coffee              | 200mL                         | 50 / 60                 |"
echo "| 8       | Cake                | 1 pound / 2 pounds / 2.5 pounds / 3 pounds / 4 pounds  | 120 / 170 / 220 / 260 / 300 |"
echo "-------------------------------------------------------------------------------------------"

# Display dynamic menu items (added by admin)
if [ -f "menu.txt" ]; then
    # Skip the first 8 predefined lines
    awk 'NR>8 {print "| " NR " | " $0 " |"}' menu.txt
fi

echo "-------------------------------------------------------------------------------------------"

# Function to calculate price for a given menu item and quantity
calculate_price() {
    item_number=$1
    quantity=$2

    # Predefined prices for the first 8 items
    case $item_number in
        1) price=150 ;;
        2) price=100 ;;
        3) price=150 ;;
        4) price=150 ;;
        5) price=70 ;;
        6) price=30 ;;
        7) price=50 ;;
        8) price=120 ;;
        *)
            # For dynamic items (item 9 and beyond from menu.txt)
            item_line=$(sed -n "${item_number}p" menu.txt)
            
            # Extracting the first price from the dynamic item line
            price=$(echo "$item_line" | sed -E 's/.*([0-9]+).*$/\1/')

            # If no valid price is found, return a default value (e.g., 0)
            if [ -z "$price" ]; then
                price=0
            fi
            ;;
    esac

    # Calculate price for the selected quantity
    total_price=$((price * quantity))
    echo $total_price
}

# Variable for tracking the total bill
total_bill=0

# Menu interaction loop
while true; do
    echo "Please choose the food item (1-$(wc -l < menu.txt)): "
    read item_choice
    echo "Please enter the quantity:"
    read quantity

    # Get price for the selected item
    item_price=$(calculate_price $item_choice $quantity)
    
    # Update total bill
    total_bill=$((total_bill + item_price))
    echo "Total bill so far: $total_bill Tk"

    # Ask if the user wants to add more items
    echo "Do you want to add another item (y/n)?"
    read add_more
    if [ "$add_more" != "y" ]; then
        break
    fi
done

# Save order to order history
echo "$name's Order: Total Bill: $total_bill Tk" >> order_history.txt

# Final bill display
echo "Final Bill: $total_bill Tk"
echo "Thank you for your order, $name! We hope to see you again soon!"
