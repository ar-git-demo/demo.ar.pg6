public interface BotHandler {
    //Calling the Method
    BotResponse handle(String utterance, String[] params, Map<String, String> session, String fileName, String fileContent);
    
}