/**
 * Licensed to Jasig under one or more contributor license
 * agreements. See the NOTICE file distributed with this work
 * for additional information regarding copyright ownership.
 * Jasig licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a
 * copy of the License at:
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on
 * an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.jasig.portlet.calendar;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

/**
 * PredefinedCalendarConfiguration represents a user configuration of a built-in
 * calendar definition.  There may be many configurations for each predefined
 * calendar definition.  This class defines an extra place to put user-specific
 * configuration information and preferences.
 *
 * @author Jen Bourey
 */
public class PredefinedCalendarConfiguration extends CalendarConfiguration {

	private Map<String, String> preferences = new HashMap<String, String>();
	
	/**
	 * Default constructor
	 */
	public PredefinedCalendarConfiguration() {
		super();
		setCalendarDefinition(new PredefinedCalendarDefinition());
	}
	
	/**
	 * Get the user-specific preferences for this configuration.
	 * 
	 * @return
	 */
	public Map<String, String> getPreferences() {
		return preferences;
	}
	
	/**
	 * Set the user-specific preferences for this configuration.
	 * 
	 * @param preferences
	 */
	public void setPreferences(Map<String, String> preferences) {
		this.preferences = preferences;
	}
	
	/**
	 * Add a user preference for this configuration.
	 * 
	 * @param name		parameter name (key)
	 * @param value		value to be stored
	 */
	public void addPreference(String name, String value) {
		this.preferences.put(name, value);
	}
	
	/*
	 * (non-Javadoc)
	 * @see org.jasig.portlet.calendar.CalendarConfiguration#setCalendarDefinition(org.jasig.portlet.calendar.CalendarDefinition)
	 */
	@Override
	public void setCalendarDefinition(CalendarDefinition definition) {
	    if (!(definition instanceof PredefinedCalendarDefinition)) {
	        throw new IllegalArgumentException("Predefined calendar configurations may only point to a predefined calendar definition");
	    }
		super.setCalendarDefinition(definition);
	}

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof PredefinedCalendarConfiguration)) return false;
        if (!super.equals(o)) return false;

        PredefinedCalendarConfiguration that = (PredefinedCalendarConfiguration) o;

        if (!preferences.equals(that.preferences)) return false;

        return true;
    }

    // Do not replace with org.apache.commons.lang.builder.HashCodeBuilder without adjusting Hibernate Session or you will get
    // org.hibernate.LazyInitializationException: failed to lazily initialize a collection of role:
    // org.jasig.portlet.calendar.PredefinedCalendarDefinition.userConfigurations, no session or session was closed
    @Override
    public int hashCode() {
        int result = super.hashCode();
        Set sortedKeys = new TreeSet(preferences.keySet());
        Iterator<String> key = sortedKeys.iterator();
        while (key.hasNext()) {
            String keyName = key.next();
            result = 31 * result + preferences.get(keyName).hashCode();
        }
        return result;
    }
}
