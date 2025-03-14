# Pantheon  
**Short Description:**  
Pantheon is a project from Rema that will give the customer the opportunity to scan a QR code on the bottle deposit machine with their phone, and get the deposit receipt in the app. From there the customer can choose if they want to deposit the money to their account, use a EAN code and scan it at the checkout or deposit it to a association/organization.  

## About the project  
- This project is in an early phase.
- All data in the app is generated randomly from mock data
- Nothing is connected to backend yet. Rema needs to sort out how and what first, but they are planning to use a Rest-API
- There has not been any design made from Rema yet. All the design that has been made was done by Shortcut and was intended to be similar to the the R-app (Rema app/Æ app).
- The pages in the app are made to demonstrate how it could look and to present an idea, with some elements based on what the customer scoped from Rema.

## Description of the pages  
- The landing page is where all your deposit receipts (pantelappene) are. They are not necessarily used yet, but they have a tag to show their state. The four states are, New, Neutral (no tag is shown), Expiring Soon and Used. You can sort them based on their tag state in a bottom toolbar. If you click on one of the receipts, the Payment Sheet will open.
There is also a scanner icon button in the top right corner that takes you to the QR scanner.
- The scanner view is made similar to the Scan Store scanner in the R-app (Rema app/Æ-app). There is a cancel button to go back to the home/landing page. If you scan a QR code, it takes you to the Scanned Success sheet. This is a summary of what you have scanned. For now this is mock data that is random selcted. From there, you click OK to return to the home page, where the list is updated with the new receipt.
- When a receipt is clicked on the home page, you are taken to the Payment sheet, where there is a list of three buttons with options for how to transfer or use the money.
- The first choice is to transfer the money to your account. If that button is pressed, a summary sheet appears where you can either confirm or cancel. "
- The second choice is to transfer the money to the checkout. This means that when this button is clicked, a sheet appears with an EAN code to use or scan at the checkout. This screen only has an 'X' because there is nothing to confirm—only to close.
- The last option is to transfer the money to an association or organization. When this is clicked, it opens a sheet with a list of organizations and associations. If I understood the back-end developers at ... correctly, this list will vary from store to store, so it needs to be fetched from the backend. If cancel is clicked you go back to the home page. If one of the associations is clicked, a summary sheet appears, similar to the one on the transfer-to-account sheet. From this page, you can cancel and go back to the previous page, or click 'Change' to return to the previous page and select a different association, or you can confirm.

## Backend (Nothing ready yet)  
- When the app starts, it needs to fetch all deposit receipts from the backend to display in the app. It should also notify the user if any receipts are old or close to expiring.
- When the QR code on the deposit machine is scanned, the app needs to fetch that deposit receipt from the backend.
- When the deposit receipt is used to transfer to an account or association, it needs to send a request to the backend confirming the transfer. Then, it needs to fetch the updated deposit receipts. When it is scanned at checkout, the ... store needs to inform the backend that the receipt has been used. After that, we need to fetch all deposit receipts, including the update for the one that was just used.
- There might be other things as well, but many features are not ready in the backend yet.

  
