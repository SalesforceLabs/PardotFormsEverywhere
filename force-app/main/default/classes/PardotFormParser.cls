public class PardotFormParser {

	public class Values {
		public Integer id;
		public String afterFormContent;
		public String beforeFormContent;
		public Integer campaignId;
		public String checkboxAlignment;
		public String embedCode;
		public String labelAlignment;
		public Integer layoutTemplateId;
		public String name;
		public String radioAlignment;
		public String submitButtonText;
		public String thankYouContent;
	}
	public List<Values> values;


	public static PardotFormParser parse(String json) {
		return (PardotFormParser) System.JSON.deserialize(json, PardotFormParser.class);
	}
}