package xrulz;
//import com.oracle.determinations.interview.engine.local.LocalInterviewEngine.*;
//import com.oracle.determinations.engine.Session;
import com.oracle.determinations.interview.engine.InterviewSession;
import com.oracle.determinations.interview.engine.SecurityToken;
import com.oracle.determinations.interview.engine.data.TransactionResult;
import com.oracle.determinations.interview.engine.data.model.InterviewUserData;
//import com.oracle.determinations.interview.engine.events.handlers.OnSessionCreatedEventHandler;
//import com.oracle.determinations.interview.engine.events.OnSessionCreatedEvent;
//import com.oracle.determinations.interview.engine.local.LocalInterviewEngine;
//import com.oracle.determinations.interview.engine.plugins.InterviewSessionPlugin;
//import com.oracle.determinations.interview.engine.plugins.InterviewSessionRegisterArgs;
import com.oracle.determinations.interview.engine.plugins.data.DataAdaptorPlugin;
import com.oracle.determinations.interview.engine.security.BasicSecurityToken;
import com.oracle.determinations.web.platform.controller.SessionContext;
import com.oracle.determinations.web.platform.eventmodel.events.OnGetScreenEvent;
import com.oracle.determinations.web.platform.eventmodel.events.OnInvestigationEndedEvent;
import com.oracle.determinations.web.platform.eventmodel.events.OnRequireSessionEvent;
import com.oracle.determinations.web.platform.eventmodel.handlers.OnGetScreenEventHandler;
import com.oracle.determinations.web.platform.eventmodel.handlers.OnInvestigationEndedEventHandler;
import com.oracle.determinations.web.platform.eventmodel.handlers.OnRequireSessionEventHandler;
import com.oracle.determinations.web.platform.plugins.PlatformSessionPlugin;
import com.oracle.determinations.web.platform.plugins.PlatformSessionRegisterArgs;

import java.util.List;

import org.apache.log4j.Logger;


/*
* file:///C:/OPA/OPA_Runtime_Java_v10.4.0.145.0/help/api/web-determinations-doc/index.html
* public final class OnRequireSessionEvent 
* extends java.lang.Object 
* implements PlatformEvent 
* An Oracle Web Determinations Platform event fired when a Web Determinations request requires 
* an Interview Session which is not available (for example where a session has not already been created 
* or has expired). 
* An OnRequireSessionEvent event handler registered to handle this event may construct and 
* provide a valid interview session for use. 
* Allows non-affinity based clustering (for clustered web-servers) to work, 
* since the handler will allow initialization and loading of Interview Session data 
* (together with a DataAdaptor).
* 
*/

public class SaveEventTriggers implements OnRequireSessionEventHandler, OnGetScreenEventHandler, OnInvestigationEndedEventHandler {
    private final String validRegistrationRulebaseName = "BaseLine";
    private Logger log = null;
    
    //Parameter-less constructor to satisfy OPA Plugin requirement    
    public SaveEventTriggers() {
        log = Logger.getRootLogger();
        log.info("xRulz: SaveEventTriggers Parameterless Constructor Called");

    }
    
    //Trigger loading of an initial session when called for by OWD
    @Override
    public void handleEvent(Object sender, OnRequireSessionEvent event) {
        
        SessionContext currentContext = (SessionContext) sender;
        //currentContext.getCurrentScreen().getId();
        Logger log = Logger.getRootLogger();

        log.info("OnRequireSessionEvent URI:" + event.getRequestURI() + " Screen Id: " + currentContext.getCurrentScreen().getId());       
        SecurityToken token = new BasicSecurityToken("");        

        InterviewSession currentSession = currentContext.getInterviewSession();
        
        //String adaptorString = currentSession.getDataAdaptor().toString();
        //DataAdaptorPlugin dap = null;
        //currentSession.setDataAdaptor(dap);
        
        //Call Current (default Siebel ?) DataAdaptor to retrieve the Interview Data, load()
        InterviewUserData userData = currentSession.getDataAdaptor().load(token, currentContext.getCaseID(), currentContext.getInterviewSession().getRulebase());
        
        //Check whether this is the valid call to make (submit)  
        //ToDo
        TransactionResult tranResult = currentContext.getInterviewSession().submit(userData);
        
        if (!tranResult.isSuccess()) {
            //  Log and Raise a new Exception ???
            List lErr = tranResult.getErrors();
            log.warn("OnRequireSessionEvent Load Errors [] : " + lErr.toArray().toString() );
        }
        
    }
    
    //Triggers auto-saving during the investigation of a goal
    public void handleEvent(Object sender, OnGetScreenEvent event) {
        
        SessionContext currentContext = (SessionContext) sender;
        
        // >>>>  Changes the next screen ? event.setScreen(Screen);
        
        // Can we detect a screen attribute/property that allows us to control whether we handle this event
        // A property on the screens, set to true?
        // >>>>> currentContext.getCurrentScreen().getId()?
        
        // LIBRARIES ???
        
        // currentContext.getCurrentScreen().getPropertyValue(STRING???)
        ///currentContext.getCurrentScreen().getScreenAttribute().
        //currentContext.getInterviewSession().setDataAdaptor(DataAdaptorPlugin);  // Switches Adaptor ?
        //currentContext.getInterviewSession().setListProvider(ListProvideerPlugin);
        //currentContext.getInterviewSession().submit(InterviewUserData);
        //>>>  currentContext.getURLRewriter()
        //currentContext.getCurrentScreen().isAutomatic()
        
        log.info("OnGetScreenEvent Occurred");
        
        SecurityToken token = new BasicSecurityToken("");
        InterviewSession currentSession = currentContext.getInterviewSession();
        String caseID = currentContext.getCaseID(); // <<<<<<<<<

        //This calls the DataAdaptor save() during the investigation of a goal, autosaving on each investigation screen
        //BUT it does not autosave when the investigation is completed - thus not saving the user's answer to the last Question
        if (currentContext.getCurrentGoal() != null) {
            String newCaseID = currentSession.getDataAdaptor().save(token, currentContext.getCaseID(), currentSession);
            if (newCaseID != "")
                currentContext.setCaseID(newCaseID);
        }
    }

    //Triggers save when the investigation of a goal finishes
    @Override
    public void handleEvent(Object sender, OnInvestigationEndedEvent event) {

        log.info("OnInvestigationEndedEvent Occurred");
        SessionContext currentContext = event.getSessionContext();

        SecurityToken token = new BasicSecurityToken("");
        InterviewSession currentSession = currentContext.getInterviewSession();

        // currentSession.getRuleSession().getGlobalEntityInstance().markContainmentComplete(boolean, Entity);

        String caseID = currentContext.getCaseID();

        //This calls the DataAdaptor save() when the investigation finishes, thus saving the user's answer to the last Question
        if (caseID != null) {
            String newCaseID = currentSession.getDataAdaptor().save(token, currentContext.getCaseID(), currentSession);
            if (newCaseID != "")
                currentContext.setCaseID(newCaseID);
        }
    }
    
    @Override
    public PlatformSessionPlugin getInstance(PlatformSessionRegisterArgs args) {
        
        /* The Plugin has control on what instance of itself it returns, 
         * it is able to instantiate an instance of itself with arguments from the RegisterArgs args
         * 
        */
        
        //Demonstration of a Plugin only registering if the current rulebase is validated
        log.info("PlatformSessionPlugin getInstance( returning new SaveEventTriggers()");
        return new SaveEventTriggers();
        //return this;
        /*
        if (args.getContext().getInterviewSession() != null &&
                (args.getContext().getInterviewSession().getRulebase().getIdentifier().equals(validRegistrationRulebaseName))) {

            //return this;
        } else {
            return null;
        }
        */
    }
}
