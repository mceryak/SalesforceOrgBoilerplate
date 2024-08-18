Pre-Requisites:
1. Deploy modules/fflib
2. Deploy modules/lgr

Steps:
1. sfdx project deploy start -d modules/fflibe/main/default -l RunSpecifiedTests --tests fflibe_TriggerHandlerTest fflibe_TriggerSObjectDomainTest fflibe_UnitOfWorkTest fflibe_ApplicationTest