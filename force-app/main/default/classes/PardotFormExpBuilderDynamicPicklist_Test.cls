@isTest
    public with sharing class PardotFormExpBuilderDynamicPicklist_Test {
        @TestSetup
        public static void createData() {
          PardotForm_TestFactory.setupDefaultData();
        }
    
        @IsTest
        static void getValues() {
          Test.startTest();
          PardotFormExpBuilderDynamicPicklist picklist = new PardotFormExpBuilderDynamicPicklist();
            VisualEditor.DynamicPickListRows rows = picklist.getValues();
          Test.stopTest();
          System.assert(rows.size() == 1, 'Summary format set incorrectly');
        }
    
        @IsTest
        static void getDefaultValue() {
          Test.startTest();
          PardotFormExpBuilderDynamicPicklist picklist = new PardotFormExpBuilderDynamicPicklist();
          VisualEditor.DataRow row = picklist.getDefaultValue();
          Test.stopTest();
          System.assert(row.getLabel() == 'Standard Form', row);
        }
    
    }