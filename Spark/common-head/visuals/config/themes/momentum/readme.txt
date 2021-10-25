The momentum*.json files in this folder are all generated from the momentum tokens repo, *do not* manually add tokens as they will get overridden. See https://github.com/momentum-design/tokens for details. 

*Temporary limitations. Some manual changes are still needed*

1)The contents momentumWebexDark.json

Change 

  "name": "MomentumWebexDark",
  "parent": "WebexDark",

To

  "name": "MomentumDark",
  "parent": "Dark",

2) momentumWebexDark.json file needs to be renamed to momentumDark.json

3) The content of momentumWebexLight.json 

Change 

  "name": "MomentumWebexLight",
  "parent": "WebexLight",

To

  "name": "MomentumDefault",
  "parent": "Default",

4)
momentumWebexLight.json  file needs to be renamed to momentumDefault.json

5)
Replace  "active": to  "checked": in all files

