# Pantheon  
**Short Description:**
Pantheon is a project from Rema that will give the customer the opportunity to scan a QR code on the bottle deposit machine with there phone, and get the deposit receipt in the app. From there the customer can choose if they want to deposit the money to ther account, use a ean code and scan it at the checkout or deposit it to a association/organization.  

---  

## About the project  
- This projcet is in an early face.
- All data in the app are genrated randomly from mock data
- There is not connected to backend yet, Rema needs to sort out how and what first. But there planning to use Rest-API
- There is not made any design from Rema yet, so all that is made is made by Shortcut and tried to make it similar to the R-app (Rema app/Æ).
- The pages in the app is made to show something og how it could look like, and from what is scoped from Rema.

---  

## Description of the pages  
- The landing page is where all your deposit receipts (pantelappene) are. They are not nessesary used yet, but they have a tag to show there state. The 4 states are, New, Neutral (no tag are shown), Almost outdated and used. You can sort them based on there tag state in a bottom tool bar. If you click on one of the receipts the Payment sheet will open.
There is also a scanner icon button in the top right corner that take you to the QR-scanner.
- The scanner view is made similar to the Scan Store scanner in the R-app (Rema app/Æ-app). There is a cancel button to go back to the home/landing page. If you scan a QR code it takes you to the ScannedSuccess sheet. This is a summary of what you have scanned. For now this is mock data that is random selcted. From there you click OK, and you go back to the home page, and the list on the home page is updated with the new receipt.
- When a receipt is clicked on the home page, you get to the Payment sheet where there are a list of 3 buttons with choices of how to transfer/use the money.
- The first choice is to tranfer to your account. If that button is pressed, a summary sheet comes up where you either can confirm or cancel. There are no confirmation yet because there is no logic for tranfering anything.
- The second choice is to tranfer to the checkout. This means that when this button is clicked, it shows a sheet with a ean code to use/scan at the checkout. This screen only have a X because there is nothing to conferm. Only close.
- The last option is to tranfer to an association/organization. When this is clicked it opens a sheet with a list of organisations and associations. If I understood the backenders at Rema correct, this list will vary from store to store, so need to get the list from backend. I cancel i clicked you go back to home page. If one of the associations are clicked a summary sheet comes up, simular to the one on the tranfer to account sheet. From this page you can cancel and go back to the last page, og click change and go back to the last page to change the association, or you can confirm.

---

## Backend  
- When the app starts it needs to get all receipts from the backend to show in the app. Also nedge the user if some receipts are old/close to expire
- When a QR are scanned, it needs to get that deposit receipt from backend/panteskyen
- When the deposit receipt is used to tranfer to account or association it need to send to backen that it has been tranfered. When it is scanned at the checkout, that Rema store need to tell backend that the receipt is used, and we need to get all deposit receipts with the update on the one that was just used.
- There might other thins as well, but there is a lot of things thats not ready in the backend yet.

  
