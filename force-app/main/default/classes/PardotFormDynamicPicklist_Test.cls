@isTest
public with sharing class PardotFormDynamicPicklist_Test {
    @TestSetup
    public static void createData() {
      PardotForm_TestFactory.setupDefaultData();
    }

    @IsTest
    static void getValues() {
      Test.startTest();
      PardotFormDynamicPicklist picklist = new PardotFormDynamicPicklist();
        VisualEditor.DynamicPickListRows rows = picklist.getValues();
      Test.stopTest();
      System.assert(rows.size() == 1, 'Summary format set incorrectly');
    }

    @IsTest
    static void getDefaultValue() {
      Test.startTest();
      PardotFormDynamicPicklist picklist = new PardotFormDynamicPicklist();
      VisualEditor.DataRow row = picklist.getDefaultValue();
      Test.stopTest();
      System.assert(row.getLabel() == 'Standard Form', row);
    }

}