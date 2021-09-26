global without sharing class PardotFormExpBuilderDynamicPicklist extends VisualEditor.DynamicPickList{
    global override VisualEditor.DataRow getDefaultValue(){
        List<plabs__PardotForm__c> forms = [SELECT Id, Name, plabs__Response__c, plabs__EmbedCode__c, plabs__FormURL__c FROM plabs__PardotForm__c WHERE plabs__Active__c = true];
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow(forms[0].Name, String.valueOf(forms[0].Id));
        return defaultValue;
    }
    global override VisualEditor.DynamicPickListRows getValues() {
        VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
        List<plabs__PardotForm__c> forms = [SELECT Id, Name, plabs__Response__c, plabs__EmbedCode__c, plabs__FormURL__c FROM plabs__PardotForm__c WHERE plabs__Active__c = true];
        for(plabs__PardotForm__c form : forms){
            VisualEditor.DataRow value = new VisualEditor.DataRow(form.Name, String.valueOf(form.Id));
            myValues.addRow(value);
        }
        return myValues;
    }

}