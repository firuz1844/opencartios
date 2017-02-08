# opencartios
This is OpenCart iOS mobile client for OpenCart REST API plugin (www.opencart-api.com)



# OpenCart iOS mobile app v.1.0
## Installation instructions
To install and run this app you need Apple Mac computer with OSX 10.11 or higher and Xcode 7.0
or higher.<br>
1. Clone project<br>
2. Open ‘opencart.xcworkspace’ file<br>
3. In Xcode open menu ‘Product > Destination > iOS’ select your device or any
other instance of iOS simulator installed on you computer.<br>
8. Press Cmd+R on keyboard or ‘Build and run button’ (Black triangle button on the left top
corner of Xcode) to run your project in the iOS Simulator.<br>

<b>Important!</b>
To run project on iOS devices, you must be registered Apple developer and need to configure
Bundle ID and Provision profiles for the project. To distribute this application on AppStore you need
to create a package signed with your distribution certificate - read more about distribution process
on Apple support website.

When application will be successfully built and ran you will be able to see categories and products
from demo OpenCart shop.

## To set up application to work with your own OpenCart website please follow Setup instructions.

To setup iOS mobile app for your own OpenCart website you need to do next steps:
1. Install appropriate third party OpenCart API v.2.0 extension on your website<br>
2. Configure iOS app to your website<br>
Installing OpenCart API extension on your website<br>
The upload folder contains all files for this module.<br>
You will notice that the folders are in the same structure as your Opencart installation.<br>
1. Install vqmod from https://github.com/vqmod/vqmod/releases (select opencart release)<br>
2. Navigate to your opencart root folder using an FTP program<br>
3. Upload the “catalog”, “admin” & “vqmod” & “system” folders to your opencart installation folder<br>
4. Go to your admin area in Extensions->Modules and enable your REST API extension<br>
5. You have to fill the Order id field (you can find it in the order email)<br>
6. You have to fill the API security key field (eg. 12345 or anything else)<br>
7. Test you OpenCart API extension by following in web browser to next address: http://YOUR_SITE_ADDRESS.com/api/rest/products. You will see {"success":false,"error":"Invalid secret key”} if extension installed successfully. If not, please follow troubleshooting section of FAQ instructions - http://opencart-api.com/faqs/<br>

## Configure iOS app to your website
After you have installed and tested OpenCart API extension please follow next instructions to link your iOS app to your OpenCart website.

1. Open opencart.xcworkspace file from the project folder<br>
2. Go to project navigate by pressing menu View > Navigator > Show Project Navigator or just press Cmd+1<br>
3. Select opencart project to see setting of project<br>
4. Select opencart_insk target from list of TARGETS<br>
5. Go to the info tab<br>
6. Expand CustomerInfo line<br>
7. Change baseUrl property with your website address (for example http://shop.insk.org/) Don't forget the ‘/‘ on the end of url.
8. Change storeName with any textual name and storePhone in international format (for example +18001234567)
9. To change color palette please play with designStyle numbers. This is RGB and alpha for main design colour. For example 239,65,54,1 - RED-239, GREEN-65, BLUE-54, ALPFA-1. Red, Green and Blue must be between 0-255 and alfa is float number between 0-1<br>
10. To use News function please register a profile on http://www.vk.com.<br>
11. Then create a Standalone Application at https://vk.com/editapp?act=create. You will need Application ID to use in our project- keep it.<br>
12. Then Create Community at https://vk.com/groups and keep Group ID.<br>
13. Insert Application ID in AppDelegate.m file line 28 and Group ID in NewsViewController.m file at line 43 with a minus sign at the begining.<br>

DONE!
