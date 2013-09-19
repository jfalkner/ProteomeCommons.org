/*
 *    Copyright 2005 The Regents of the University of Michigan
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.proteomecommons.www.message;

import java.sql.ResultSet;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import org.proteomecommons.mysql.MySQLDatabaseUtil;

/**
 *
 * @author James "Augie" Hill - augman85@gmail.com
 */
public class MessageUtil {

    private static String[] quickSearchFields = new String[]{"m.subject", "m.message"};
    public static final int CACHE_LIMIT = 4000;
    private static Map<Integer, Message> messages = new HashMap<Integer, Message>();
    private static List<Message> messageRecency = new LinkedList<Message>();
    private static Map<Integer, MessageThread> messageThreads = new HashMap<Integer, MessageThread>();
    private static List<MessageThread> messageThreadRecency = new LinkedList<MessageThread>();
    
    public static boolean isMessageThreadInCache(int threadID) {
        return messageThreads.containsKey(threadID);
    }
    
    public static boolean isMessageInCache(int messageID) {
        return messages.containsKey(messageID);
    }
    
    public static int getMessageCacheSize() {
        return messages.size();
    }
    
    public static int getMessageThreadCacheSize() {
        return messageThreads.size();
    }
    
    public static Message getMessage(int messageID) {
        return getMessage(messageID, null);
    }
    
    public static synchronized Message getMessage(int messageID, ResultSet rs) {
        // is the message in the cache?
        Message message = null;
        try {
            if (messages.containsKey(messageID)) {
                message = messages.get(messageID);
            } else {
                message = new Message(rs);
                if (!message.isSet()) {
                    ResultSet rs2 = null;
                    try {
                        rs2 = MySQLDatabaseUtil.executeQuery("SELECT m.*,u.* FROM message m INNER JOIN user u ON u.userID = m.userID WHERE m.messageID = '" + messageID + "' LIMIT 1;");
                        if (rs2.next()) {
                            message = new Message(rs2);
                        }
                    } catch (Exception e) {
                    } finally {
                        MySQLDatabaseUtil.safeClose(rs2);
                    }
                }
            }
        } finally {
            // make sure this is a message we want to cache
            if (message != null && message.isSet()) {
                // update the cache
                if (!messages.containsKey(messageID)) {
                    // remove the last message
                    while (messageRecency.size() >= CACHE_LIMIT) {
                        messages.remove(messageRecency.remove(0).messageID);
                    }
                    // this is a new one
                    messages.put(message.messageID, message);
                    messageRecency.add(message);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    messageRecency.remove(message);
                    messageRecency.add(message);
                }
            }
        }
        return message;
    }
    
    public static synchronized List <Message> getMessages(List <Integer> messageIDs) {
        List <Message> list = new LinkedList <Message> ();
        // get the messages that are in the cache
        List <Integer> toGetFromDatabase = new LinkedList <Integer> ();
        for (int messageID : messageIDs) {
            if (messages.containsKey(messageID)) {
                list.add(messages.get(messageID));
            } else {
                toGetFromDatabase.add(messageID);
            }
        }
        // get the remaining groups
        if (!toGetFromDatabase.isEmpty()) {
            String SQLFilter = "messageID = '"+toGetFromDatabase.remove(0)+"'";
            for (int messageID : toGetFromDatabase) {
                SQLFilter = SQLFilter + " OR messageID = '"+messageID+"'";
            }
            
            ResultSet rs = null;
            try {
                rs = MySQLDatabaseUtil.executeQuery("SELECT * FROM message WHERE ("+SQLFilter+");");
                while (rs.next()) {
                    list.add(new Message(rs));
                }
            } catch (Exception e) {
            } finally {
                MySQLDatabaseUtil.safeClose(rs);
            }
        }
        // update the cache
        for (Message message : list) {
            if (message != null && message.isSet()) {
                // update the cache
                if (!messages.containsKey(message.messageID)) {
                    // remove the last group
                    while (messageRecency.size() >= CACHE_LIMIT) {
                        messages.remove(messageRecency.remove(0).messageID);
                    }
                    // this is a new one
                    messages.put(message.messageID, message);
                    messageRecency.add(message);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    messageRecency.remove(message);
                    messageRecency.add(message);
                }
            }
        }
        return Collections.unmodifiableList(list);
    }
    
    public static MessageThread getMessageThread(int threadID) {
        // is the message thread in the cache?
        MessageThread thread = null;
        try {
            if (messageThreads.containsKey(threadID)) {
                thread = messageThreads.get(threadID);
            } else {
                thread = new MessageThread(threadID);
            }
        } finally {
            // make sure this is a thread we want to cache
            if (thread != null && thread.isSet()) {
                // update the cache
                if (!messageThreads.containsKey(threadID)) {
                    // remove the last message
                    while (messageThreadRecency.size() >= CACHE_LIMIT) {
                        messageThreads.remove(messageThreadRecency.remove(0).threadID);
                    }
                    // this is a new one
                    messageThreads.put(thread.threadID, thread);
                    messageThreadRecency.add(thread);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    messageThreadRecency.remove(thread);
                    messageThreadRecency.add(thread);
                }
            }
        }
        return thread;
    }
    
    public static synchronized List <MessageThread> getMessageThreads(List <Integer> threadIDs) {
        List <MessageThread> list = new LinkedList <MessageThread> ();
        // get the messages that are in the cache
        List <Integer> toGetFromDatabase = new LinkedList <Integer> ();
        for (int threadID : threadIDs) {
            if (messageThreads.containsKey(threadID)) {
                list.add(messageThreads.get(threadID));
            } else {
                toGetFromDatabase.add(threadID);
            }
        }
        // get the remaining groups
        if (!toGetFromDatabase.isEmpty()) {
            for (int threadID : toGetFromDatabase) {
                list.add(new MessageThread(threadID));
            }
        }
        // update the cache
        for (MessageThread thread : list) {
            if (thread != null && thread.isSet()) {
                // update the cache
                if (!messageThreads.containsKey(thread.threadID)) {
                    // remove the last group
                    while (messageThreadRecency.size() >= CACHE_LIMIT) {
                        messageThreads.remove(messageThreadRecency.remove(0).threadID);
                    }
                    // this is a new one
                    messageThreads.put(thread.threadID, thread);
                    messageThreadRecency.add(thread);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    messageThreadRecency.remove(thread);
                    messageThreadRecency.add(thread);
                }
            }
        }
        return Collections.unmodifiableList(list);
    }
    
    public static int getMessageCount() {
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT COUNT(messageID) AS rows FROM message;");
            rs.next();
            return rs.getInt("rows");
        } catch (Exception e) {
            return 0;
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
    }
}