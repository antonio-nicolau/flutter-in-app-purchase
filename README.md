# Flutter in-app purchase

A Flutter project to show to implement in-app purchase using the [in_app_purchase](https://pub.dev/packages/in_app_purchase) package

Simple UI but it's okay 🥲😉


https://user-images.githubusercontent.com/67912928/180670588-4e31de1a-90c8-4593-9da7-cf53f40cf2ed.mp4



## Getting Started


To getting start with this project please make sure to take those steps done:

- Flutter 3.0.0 or higher installed

- Have your app bundle sent to stores for production to activate in-app purchase, see [here](https://docs.flutter.dev/deployment/android) steps to release flutter apps

- Create product and subscription on stores. we'll use product with ID `in.app.purchase.testeproduct` and subscription `in.app.purchase.testesubscription`. See here how to do it for [Android](https://support.google.com/googleplay/android-developer/answer/1153481?hl=en#zippy=%2Ccreate-a-single-in-app-product) and [IOS](https://help.apple.com/app-store-connect/#/devae49fb316)


We'll use [in_app_purchase](https://pub.dev/packages/in_app_purchase) package. This plugin supports in-app purchases (IAP) through an underlying store, which can be the App Store (on iOS) or Google Play (on Android)

This project has examples of code for the following tasks:

- Listening to purchase updates

- Connecting to the underlying store

- Loading products for sale

- Restoring previous purchases

- Making a purchase

- Upgrading or downgrading an existing in-app subscription

- Accessing platform specific product or purchase properties (for purchase validation purposes)

> **_NOTE:_**  Please remember to always verify purchase on backend side before delivery it to user. Did add code section where you can see how to extract those data to send to your own backend



> **_NOTE:_**  This project was written using riverpod as state management but you can apply the same logic for others of your preference, feel free to change 😏


## Packages

[in_app_purchase ^3.0.6](https://pub.dev/packages/in_app_purchase)

[hooks_riverpod ^1.0.4](https://pub.dev/packages/hooks_riverpod)

[flutter_hooks ^0.18.5+1](https://pub.dev/packages/flutter_hooks)


## Contribuition

If you notice an expected behavior or would like to have any feature related in-app purchase implemented, then feel free to report or contribute with your pull request


[![Linkedin](https://i.stack.imgur.com/gVE0j.png) LinkedIn](https://www.linkedin.com/in/antonio-pedronicolau/)

