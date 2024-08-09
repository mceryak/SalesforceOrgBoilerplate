
1. Deploy Custom Settings metadata .
    - sfdx project deploy start -x deployment/lgr/manifest/lgr_package1.xml

2. Insert Org Defaults for Custom Settings.
    - /deployment/lgr/scripts/customSettingsOrgDefaults.apex

3. Deploy the rest of the metadata.
    - sfdx project deploy start -x deployment/lgr/manifest/lgr_package2.xml -l RunLocalTests

4. Assign Viewew Permissions to all Admins.
    - /deployment/lgr/scripts/assignViewerPermSet.apex