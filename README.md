[![npm version](https://badge.fury.io/js/react-native-dfp.svg)](https://badge.fury.io/js/react-native-dfp)

# react-native-dfp

Unofficial fork from Simon Bugert's [react-native-admob](https://github.com/sbugert/react-native-admob/tree/980386052d780e42042bf8127cd1048549fe7773), but only implementing Google Mobile Ads' DFP libraries.

## Getting started

`$ npm install react-native-dfp --save`

### Mostly automatic installation

`$ react-native link react-native-dfp`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-dfp` and add `RNDfp.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNDfp.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNDfpPackage;` to the imports at the top of the file
  - Add `new RNDfpPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-dfp'
  	project(':react-native-dfp').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-dfp/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-dfp')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNDfp.sln` in `node_modules/react-native-dfp/windows/RNDfp.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Com.Reactlibrary.RNDfp;` to the usings at the top of the file
  - Add `new RNDfpPackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import RNDfp from 'react-native-dfp';

// TODO: What to do with the module?
RNDfp;
```
  