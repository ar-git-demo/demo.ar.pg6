@isTest
private class UtilClassTest {

    private static final String CS_NONE_EXT = 'none';
    private static final String CS_NONE_CONTENT_TYPE = 'application/octet-stream';
    private static final String CS_TXT_EXT = '.txt';
    private static final String CS_TXT_CONTENT_TYPE = 'text/plain';

    private static testMethod void test_fetchBusinessHoursID()
    {
        List<BusinessHours> hoursList = [Select Id, Name From BusinessHours Limit 1];

        if(!hoursList.isEmpty()) {
            system.assertEquals(hoursList[0].Id, UtilClass.fetchBusinessHoursID(hoursList[0].Name));
        }

    }

    private static testMethod void test_fetchBusinessHoursID_negative()
    {

        List<BusinessHours> hoursList = [Select Id, Name From BusinessHours where isDefault = true];

        system.assertEquals(hoursList[0].Id, UtilClass.fetchBusinessHoursID('Test Business Hours'));

    }

   
    private static testMethod void test_getObjectType()
    {
        system.assertEquals('', UtilClass.getObjectType(null));
        Boolean testBoolean = false;
        system.assertEquals('Boolean', UtilClass.getObjectType(testBoolean));
        Blob testBlob = Blob.valueOf('testBlob');
        system.assertEquals('Blob', UtilClass.getObjectType(testBlob));
        Date testDate = Date.today();
        system.assertEquals('Date', UtilClass.getObjectType(testDate));
        Datetime testDatetime = Datetime.now();
        system.assertEquals('Datetime', UtilClass.getObjectType(testDatetime));
        Decimal testDecimal = Decimal.valueOf(0);
        system.assertEquals('Decimal', UtilClass.getObjectType(testDecimal));
        Double testDouble = Double.valueOf(0);
        system.assertEquals('Decimal', UtilClass.getObjectType(testDouble));
        Integer testInteger = Integer.valueOf('0');
        system.assertEquals('Integer', UtilClass.getObjectType(testInteger));
        List<Object> testList = new List<Object>();
        system.assertEquals('List', UtilClass.getObjectType(testList));
        Long testLong = Long.valueOf('0');
        system.assertEquals('Long', UtilClass.getObjectType(testLong));
        system.assertEquals('Account', UtilClass.getObjectType(new Account()));
        String testString = 'sdfsdf';
        system.assertEquals('String', UtilClass.getObjectType(testString));
        Time testTime = Time.newInstance(9, 1, 1, 1);
        system.assertEquals('Time', UtilClass.getObjectType(testTime));
        Map<String, Object> testMap = new Map<String, Object>();
        system.assertEquals('Object', UtilClass.getObjectType(testMap));

    }

    private static testMethod void test_toTitleCase() {

        system.assertEquals('The Quick Brown Fox', UtilClass.toTitleCase('the quick brown fox'));
        system.assertEquals('The Days of Our Lives', UtilClass.toTitleCase('the days of our lives'));
        system.assertEquals('Oh My God', UtilClass.toTitleCase('OH MY GOD'));
        //Item-01989 - Test string with extra spaces
        system.assertEquals('Too Many Spaces', UtilClass.toTitleCase(' too  many  spaces '));

    }
}