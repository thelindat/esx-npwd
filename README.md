# NPWD compatibility wrapper for ESX
Setup event handlers and export calls to create the player instance within NPWD after an xPlayer has loaded, ensuring correct no-fuss loading and minimal effort.

- Tested with ESX Legacy
- Should work with ESX v1 Final and v1.2
- Completely untested with ESX v1.1 (can't wait)

Like NPWD, this resource is still a work-in-progress and may require alterations to improve support. Currently, you will need to build NPWD yourself from the `develop` branch (the pre-release will _not_ work).

## Note
It is recommended that you integrate this functionality into your framework, but it's entirely up to you.  
If you are using the Overextended fork of ESX then this resource is _not required_.
