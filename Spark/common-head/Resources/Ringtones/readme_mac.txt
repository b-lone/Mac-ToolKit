
If you add a file to this directory and you wan it to be used as a ringtone
or message notification sound then there are other steps you should take to
make it usable on Mac.
1. Add the new resource to the Cisco Spark/Resource Files/ringtones group in the xcode project. This will automatically add the file as a resource so it will
appear in the resources folder of the generated app.
2. Manually add the file to the resources in the Developer Harness target. This
wil avoiid file not found errors being reported form UI tests.
3. Update ./SparkMacDesktop/SparkMacDesktop/ResourceLoader.mm to list the new
sound as a ringtone or a message notification or both.

