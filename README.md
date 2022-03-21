# Purdue Farmer's Market

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
The app is designed to connect Farmers with their customers through an easy-to-use display of farmer inventory and stock. The app will incorporate communication between users and farmers, as well as a map that allows users to see where and when Farmer’s markets will be open.

### App Evaluation
[//]: # ([Evaluation of your app across the following attributes])

- **Category:** Shopping
- **Mobile:** Allows for users to quickly view and see real time changes to a vendor's inventory, as well as utilize a map to find where Farmer's markets are and when they are open.
- **Story:** Provides Purdue residents an easy gateway into going to Farmer's markets, while also offering an opportunity for vendors to have another way to sell their goods.
- **Market:** People interested in buying fresh goods, gives vendors a unified and directed means of selling their goods to people.
- **Habit:** Any user interested in buying goods, specifically locals and Purdue students, will open this app to see updates on farmers markets regularly to stay on top of changes in stock. The average user will see the stock of the market, and be capable of messaging vendors questions about their goods. Vendors will update their stock, add and remove items, and show the location of their market.
- **Scope:** The app has a defined purpose, to provide a view for users to see the stock of vendors at Farmer's markets. The app will incorporate a database and API that will update live upon the request vendors, a map that will show the location and times of a vendor, and a messaging feature that connects users with vendors.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Database with vendors and available items per vendor
* Vendor can include image for item
* Vendor can update items and availability
* Display of available items
* Vendors can register account
* User can log in and log out

**Optional Nice-to-have Stories**

* Pull to refresh
* Multiple markets available
* Able to purchase/reserve items 
* Logged in across restarts

### 2. Screen Archetypes

* Vendor screen
   * Provides a list of all vendors that are coming to the next farmers' market.
 
* Item screen
   * Provides a list of all items that available for the next farmers' market.

* Map screen
    * Shows through google map with pin on the vendors' stands.
    * Allows users to check vendors profile through the pin.

* Message screen
    * Allows users to send/receive message from another user.

* Login
    * Allows users choose account type and login to their accounts

* Register
    * Allows users register for a new account

* Customer setting screen
    * Allows customers(a sub-class of Users) can modify their personal information and preference. 
    * They could upload/change profile names and pictures and modify their favourite items/vendors.

* Vendor setting screen
    * Allows vendors(a sub-class of Users) use this area to promote their product.
    * They could add stories, add new items, upload pictures, update information. 

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Vendors
* Items
* Map
* Message
* Profile

**Flow Navigation** (Screen to Screen)

* No forced log-in, starts the app with map screen.
* Profile 
    * Profile -> login -> vendor/customer homepage -> vendor/customer setting 
    * Profile -> register if no login available

## Wireframe
<img src="https://i.imgur.com/Cdl34oO.png" width=600>


### [BONUS] Digital Wireframes & Mockups
![](https://i.imgur.com/kZ6U5GM.png)

### [BONUS] Interactive Prototype
[Figma Protytpye](https://www.figma.com/proto/gnT4JnrHm92UqAGqXoHSuA/Farmer's-Market?page-id=0%3A1&node-id=3%3A51&viewport=241%2C48%2C0.49&scaling=scale-down&starting-point-node-id=3%3A51)

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- Login
    - Login Request
- Signup 
    - Signup Request
- Home page
    - Get Vendors (param: search params, if given)
    - Get Favorites
- Vendor info page
    - Get Vendor Info (param: selected vendor id)
    - Get Goods (param: selected vendor id)
    - Get Favorites (param: selected vendor id, for filter)
- Good info page
    - Get Good Info (param: selected good id)
        - Will automatically give reviews inside this request
    - Add Favorite
    - Remove Favorite
- Review Page (click + to add new review or click modify to modify previous review)
    - Add Review (params: review information and good id. User id will be determined from auth token)
    - Modify Review (params: review information and review id)
- Messages tab
    - Get conversations (returns list of people)
- Message tab (after clicking a person)
    - Get messages (params: person id, and pagination values)
    - Send message (params: message, person id)
- User Settings Page
    - Get User Settings (no param needed, get user by auth token)
    - Save User Settings (params: changed settings)
- Modify Goods Page
    - Get Goods
- Add New Good Page
    - Add Good (param: inputed vals)
- Modify Good Page
    - Get Good Info (param: selected good id)
    - Modify Good Info (param: inputed values and id)
    - If want to delete, use Modify Good Info with delete param.
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
