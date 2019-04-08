## FeedbackSDK  (v 1.0.0)

## Requirements
platform: iOS 9 or greater
NSAppTransportSecurity: (For app transport security see the example's info plist file.)

## Installation

FeedbackSDK is available through private repo [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod 'FeedbackSDK', :git => 'https://github.com/m23perrault/FeedbackSDK.git'

```

## For Specific tag implimenation-

```
pod 'FeedbackSDK', :git => 'https://github.com/m23perrault/FeedbackSDK.git',:tag => '0.1.2'

```

**************************************
``` Basic Implimentation ```

FeedbackSDKManager is a singleton class. To instantiate,

```
import FeedbackSDK
```
FeedbackSDKManager will be initialized as follows.

```

FeedbackSDKManager.sdkInstance.initSDKWithAppId_SecretKey(SDK_APP_ID: "app_id", SDK_APP_SECRET_KEY: "secret_key") { (status, err) in

};

```

##### SDK_APP_ID
The SDK_APP_ID provided by the Web .

##### SDK_APP_SECRET_KEY
Device unique id used by the app.

#####  WebLink
http://apptenium.com/index.php?r=user%2Fdashboard

#### FeedbackSDK feedback drop implimenation
#### method
showFeedbackViewController()

```
FeedbackSDKManager.sdkInstance.showFeedbackViewController()
```

#### App Rating popup Implimentation
#### FeedbackSDKManager has following properties.

Property|Type|Description|Default Value
--|---|--|--
DEFAULT_TITLE|String|Default Title to show over popup.(optional)|Rate Me
DEFAULT_RATE_TEXT|String|Default Description to show over popup.(optional)|Hi! If you like this App, can you please take a few minutes to rate it? It help so much when you do , thanks!
DEFAULT_YES_RATE|String|Default text for yes action to show over popup.(optional)|yes
DEFAULT_MAY_BE_LATER|String|Default text for may be later action to show over popup.(optional)|Maybe Later
DEFAULT_NO_THANKS|String|Default text for no thanks action to show over popup.(optional)|No, Thanks
DEFAULT_DAYS_BEFORE_PROMPT|Int|Default value in days to show popup to user.(optional)|3
DEFAULT_LAUNCH_BEFORE_PROMPT|Int|Default value in number to max show popup to user.(optional)|7

## Author

aravindkumar, anshapp89@gmail.com

## License

FeedbackSDK is available under the MIT license. See the LICENSE file for more info.
