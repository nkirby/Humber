# Humber

Thanks for getting started with Humber.

### Getting Started

#### Cocoapods

Humber uses cocoapods to manage 3rd party dependencies

1. Install Cocoapods (instructions available [here](http://cocoapods.org))
2. Open the `Humber` repo in your trusty terminal 
3. Run `pod install`

#### Github

You'll need a Github application's keys to continue with authentication. They're stored, for now, in a json file loaded into the `Humber.xcodeproj`. In the future it'll make far more sense to use `cocoapods-keys` or another similar tool.

4. Generate a Github application. You can do so [here](https://github.com/settings/applications/new)
5. Generate a `keys.json` file in `/Humber/_config`. There is an `keys_sample.json` file to show you what you need. It will look like:

```
{
    "github_client_id": "YOUR KEY HERE",
    "github_client_secret": "YOUR SECRET HERE",
    "github_redirect_uri": "YOUR REDIRECT URI HERE"
}
```

#### Routing

Internally, Humber uses `JLRoutes` to provide a routing system somewhat similar to most web front ends. By default the app uses `humber://` as the URL scheme, but if you wish to change it you'll need to edit `/Humber/_config/debug.json` and `/Humber/_config/release.json`

```
{
    "route_scheme": "yourscheme"
}
```

If you make this change, you'll need to adjust the URI types that Humber registers in the `Humber.xcodeproj` file itself.

#### Signing

If you want to deploy Humber to your device, please change the bundle identifier to something besides `com.projectspong.Humber`. 

## Additionally

Issues, Pull Requests, Comments, etc... are appreciated. This is just a prototype app, hope you like it.

Nathaniel Kirby

[nkirby.ps@gmail.com](mailto:nkirby.ps@gmail.com)