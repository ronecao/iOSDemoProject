### 3.5.1
* Remove support for Attache reader
* Fixed transaction result not being returned on cancelled EMV transaction  (issue 64)
* Improved messaging on prematurely disconnected A200 reader (issue 47)
* Voids and Refunds now accept callback URLs
* Added ability to start contact transaction on B550 with card inserted
* Fix vault feature
* Added support for receipt data from a CFTCharge
* Removed subspecs from podspec

### 3.5
* Added support for Bluetooth readers
* Add ability to charge a vaulted card
* Wrapped up commlink error from A200 (issue 42)
* Fix for crash on signature upload (issue 56)
* Added error for no audio permissions in the host app
* Updated enumerations
* Updated keyed entry view touch target

### 3.2.1
* Fix for EMV signature method
* Restored functionality to deprecated setAPIKey method (issue 46)
* Deprecated attache reader class. Support for this reader type will be removed in a future release. Please contact support@cardflight.com if you need an alternative solution

### 3.2
* Fixed Card Removed error (issue 32)
* Added completion callback after setting API Key and Account Token (issue 34)
* Fixed EMV Messaging (issue 35, 38)
* Improved EMV Reader connection logic (issue 36)

### 3.1
* Cleaned up compiler warnings
* Added destroy reader method

### 3.0
* Added EMV support
* Added iOS 9 support
* Removed iOS 6 support
* Added bitcode support

### 2.0.6
* Update to expiration date

### 2.0.5
* Update to EMV backend
* Fix for last4 when card number is blank
* Added ability to save log statements to a file

### 2.0.4
* Fix for multiple transactions in a row

### 2.0.2
* Improved reader connection reliability

### 2.0.2
* Documentation clarification
* Improved reader connection times

### 2.0.1
* Bug fix for beginSwipe method

### 2.0
* Added support for multiple readers
* Added new transaction method
* Added new CFTReader delegate methods
* Removed all previously deprecated methods

### 1.9.1
* Added fix for connecting to iPhone 6/6 Plus

### 1.9
* Added methods for auth and capture
* Added optional zip code to manual entry

### 1.8.3
* Additional fix for file corruption

### 1.8.2
* Fix for file corruption

### 1.8.1
* Fixed Attache reader supspec

### 1.8
* Added 64-bit support

### 1.7.1
* Fixed bug with refund amount, now accepts amounts in dollar and cents

### 1.7.0
* Added metadata to charges
* Created new refund method

### 1.6.3
* Added ability to copy and serialize CFTCharge
* Improved deprecation warnings
* Updated documentation

### 1.6.2
* Exposed encrypted swipe data

### 1.6.1
* Created separate static libraries for shuttle and attache readers

### 1.6
* Changed to subspec for Attache reader class (pod 'CardFlight/Attache')
* Changed CardFlight class to CFTSessionManager
* Added Void function

### 1.5.0
* Changed custom manual entry to unified field
* Added manual entry protocol
* Deprecated old version of manual entry
* Added support for NSCopying of CFTCard
* Change readerDelegate to CFTReaderDelegate

### 1.4.0
* Added 64 bit support
* Added flag for attache reader
* Deprecated connect and disconnect methods

### 1.3.0
* Added name field for custom manual entry
* Added text field delegate forwarders for custom manual entry
* Bugfixes

### 1.2

* Added logging mode for debugging
* Added becomeFirstResponder forwarder
* Added textFieldShouldReturn protocol method

### 1.1.3

* Added callback for user cancelled swipe
* Fixed callback for reader timeout
* Fixed ability to change account token

### 1.1.2

* Fixed url encoding of transaction descriptions

### 1.1.1

* Added support for reading swipes from generic cards
* Fixed tokenization card errors

### 1.1.0

* Added support for new readers
* Added support for timeout duration

### 1.0.2

* Fixes bug with errors returning nil

### 1.0.1

* Minor bug fixes

### 1.0.0

* Initial release
