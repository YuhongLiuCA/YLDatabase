trigger OpportunityTrigger on SOBJECT (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if(trigger.isBefore) {
        if(trigger.isDelete){
            for(Opportunity currOpportunity : trigger.new) {
                if(currOpportunity.stageName == 'Closed Lost' || currOpportunity.stageName == 'Closed Lost') {
                    currOpportunity.addError('Can not delete this opportunity.');
                }
            }
        }
    }
}