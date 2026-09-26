# E-Commerce App UI

## Introduction

A clean and intuitive **E-Commerce App** built using **Swift**, **Xcode**, and modern iOS UI practices.  
This project includes:

- **Landing Screen**
- **Home Screen**
- **Product Listing Screen**
- **Product Details Screen**
- **Cart Screen**


The app supports dynamic layouts, API integration, smooth navigation, and a fully functional cart system.

---

## Screens Included

- **Home Screen**: Displays categories, banners, and featured products  
- **Product Listing Screen**: Shows products with price, rating, and category filters  
- **Product Details Screen**: Shows product images, description, price, and add-to-cart  
- **Cart Screen**: View added products, update quantity, and proceed to checkout  


---

## Features

### Home Screen

- Dynamic **banner carousel** with smooth page control  
- Category list with horizontal scrolling  
- Product list fetched using a REST API  
- Search bar integrated for filtering products  


---

### Liked Products Feature

- Users can like/unlike products from Product Listing and Details screens  
- Liked products are saved locally for persistence across sessions
- Pop up showing "Add to wishlist" when product is liked
- Pop up showing " Remove from wishlist " when removed from product is unlinked

---

### Item Listing Screen

- Grid-style product display  
- Products fetched from live API  
- Supports **Add to Cart** directly from the product cell  
- Displays:
  - Product thumbnail  
  - Product name  
  - Price  
  - Rating  

---

### Product Details Screen

- Full product information:
  - Large product image carousel  
  - Price, rating, and category  
  - Detailed description  
- Add to Cart button with quantity handling  
- Supports showing related items  
- Title auto-adjusts dynamically for long product names  

---

### Cart Screen

- Displays all added products  
- Update quantity (increase/decrease)  
- Auto-updated cart subtotal  
- Dynamic table view height adjustment  
- Proceed to checkout button  
- Core Data integration (if implemented)  

---

## API Integration

- Uses **DummyJSON API** for fetching:
  - Product list  
  - Product categories  
  - Product details  
- JSON decoded using `Codable` models  
- Error handling for failed network calls  

---



## Prerequisites

- Xcode 13.0 or later  
- iOS 14.0 or later  
- Swift 5.0 or later  

---

## License

This project is open source.

---

## Contributing

Contributions are welcome.  
Feel free to open an issue or submit a pull request.

---

## Acknowledgements  
Thanks to the **Apple Developer Community** for their frameworks and documentation,  
which greatly facilitated the development of this project.

---

## Screenshots
<div style="display: flex; gap: 10px;">
  <img src="https://github.com/user-attachments/assets/99a0ff34-adb5-45ce-8ffd-54622ff7a002" width="250" alt="Landing Screen ">
  <img src="https://github.com/user-attachments/assets/589363bd-3307-4376-b758-39ad6fe016ee" width="250" alt="E-Commerce Screen 1">
  <img src="https://github.com/user-attachments/assets/54997a03-4e38-43db-a236-41142478e9c4" width="250" alt="E-Commerce Screen 2">
  <img src="https://github.com/user-attachments/assets/35956f57-cd38-46c3-a455-ed62c17816e4" width="250" alt="E-Commerce Screen 3">
  <img src="https://github.com/user-attachments/assets/8114aad6-1aea-4092-91cc-063af9b57ede" width="250" alt="E-Commerce Screen 4">

</div>
<div style="margin-top: 20px;">
  <img src="https://github.com/user-attachments/assets/54471739-a03a-478d-bb1e-7fdffbfc67f4" width="300" alt="App Demo GIF">
  
</div>




