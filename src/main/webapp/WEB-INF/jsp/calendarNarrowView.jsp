<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--

    Licensed to Jasig under one or more contributor license
    agreements. See the NOTICE file distributed with this work
    for additional information regarding copyright ownership.
    Jasig licenses this file to you under the Apache License,
    Version 2.0 (the "License"); you may not use this file
    except in compliance with the License. You may obtain a
    copy of the License at:

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on
    an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied. See the License for the
    specific language governing permissions and limitations
    under the License.

--%>

<jsp:directive.include file="/WEB-INF/jsp/include.jsp"/>
<jsp:directive.include file="/WEB-INF/jsp/css.jsp"/>

<c:set var="n"><portlet:namespace/></c:set>
<portlet:actionURL var="showDatePickerURL" escapeXml="false"><portlet:param name='action' value='showDatePicker'/><portlet:param name='show' value='true'/></portlet:actionURL>
<portlet:actionURL var="hideDatePickerURL" escapeXml="false"><portlet:param name='action' value='showDatePicker'/><portlet:param name='show' value='false'/></portlet:actionURL>
<jsp:directive.include file="/WEB-INF/jsp/scripts.jsp"/>

<div id="${n}container" class="${n}upcal-miniview">
    <div class="upcal-events">
        <div class="upcal-event-view">
            <div class="row-fluid">
                <div class="span4">
                    <!-- Range Selector -->
                    <div id="${n}calendarRangeSelector" class="upcal-range">
                        <h3><spring:message code="view"/></h3>
                        <span class="upcal-range-day" days="1">
                            <a days="1" href="javascript:;" class="${ model.days == 1 ? "selected-range" : "" }">
                                <spring:message code="day"/>
                            </a>
                        </span>
                        <span class="upcal-pipe">|</span>
                        <span class="upcal-range-day" days="7">
                            <a days="7" href="javascript:;" class="${ model.days == 7 ? "selected-range" : "" }">
                                <spring:message code="week"/>
                            </a>
                        </span>
                        <span class="upcal-pipe">|</span>
                        <span class="upcal-range-day" days="31">
                            <a days="31" href="javascript:;" class="${ model.days == 31 ? "selected-range" : "" }">
                                <spring:message code="month"/>
                            </a>
                        </span>
                        <span class="upcal-pipe">&nbsp;&nbsp;&nbsp;</span>
                        <h3><spring:message code="date.picker"/></h3>
                        <span class="upcal-range-datepicker">
                            <a show="true" href="javascript:;" id="${n}showDatePicker" class="${model.showDatePicker == 'true' ? 'selected-range' : '' }">
                                <spring:message code="show"/>
                            </a>
                        </span>
                        <span class="upcal-pipe">|</span>
                        <span class="upcal-range-datepicker">
                            <a show="false" href="javascript:;" id="${n}hideDatePicker" class="${model.showDatePicker == 'false' ? 'selected-range' : '' }">
                                <spring:message code="hide"/>
                            </a>
                        </span>
                    </div>
                    <!-- Mini-Calendar (jQuery UI) -->
                    <div class="upcal-inline-calendar"></div>
                </div>
                <div class="span8">
                    <!-- Calendar Events List -->
                    <div class="upcal-loading-message portlet-msg-info portlet-msg info">
                        <p><spring:message code="loading"/></p>
                    </div>

                    <div class="upcal-event-errors portlet-msg-error" style="display:none"></div>

                    <div class="upcal-event-list" style="display:none"></div>
                </div>
            </div>
            <div class="row-fluid">
                <!-- View Links -->
                <div class="upcal-view-links span12">
                    <a id="${n}viewMoreEventsLink" class="upcal-view-more" 
                            href="<portlet:renderURL windowState="maximized"/>"
                            title="<spring:message code="view.more.events"/>">
                        <spring:message code="view.more.events"/>
                    </a>
                    
                    <a id="${n}returnToCalendarLink" class="upcal-view-links" href="javascript:;" 
                            style="display:none" title="<spring:message code="return.to.calendar"/>">
                        <spring:message code="return.to.calendar"/>
                    </a>
                </div>
            </div>
        </div>

        <div class="upcal-event-details" style="display:none">

            <div class="upcal-event-detail">
            </div>

            <div class="utilities upcal-list-link">
                <a class="upcal-view-return" href="javascript:;" 
                        title="<spring:message code="return.to.calendar"/>" data-role="button">
                    <spring:message code="return.to.calendar"/>
                </a>
            </div>

        </div>
    </div>
</div>

<!-- Templates -->

<script type="text/template" id="event-list-template">
    ${"<%"} if (_(days).length == 0) { ${"%>"}
        <div class="portlet-msg-info">
            <p>No events</p>
        </div>
    ${"<%"} } else { ${"%>"}
        ${"<%"} _(days).each(function(day) { ${"%>"}
            <div class="day">
                <h2>${"<%="} day.displayName ${"%>"}</h2>
                ${"<%"} day.events.each(function(event) { ${"%>"}
                    <div class="upcal-event-wrapper">
                        <div class="upcal-event upcal-color-${"<%="} event.attributes.colorIndex ${"%>"}">
                            <div class="upcal-event-cal">
                                <span></span>
                            </div>
                            <span class="upcal-event-time">
                                ${"<%"} if (event.attributes.allDay) { ${"%>"}
                                    All Day
                                ${"<%"} } else if (event.attributes.multiDay) { ${"%>"}
                                    ${"<%="} event.attributes.dateStartTime ${"%>"} - ${"<%="} event.attributes.dateEndTime ${"%>"}
                                ${"<%"} } else if (event.attributes.endTime && (event.attributes.endTime != event.attributes.startTime || event.attributes.startDate  != event.attributes.endDate ) ) { ${"%>"}
                                    ${"<%="} event.attributes.startTime ${"%>"} - ${"<%="} event.attributes.endTime ${"%>"}
                                ${"<%"} } else { ${"%>"}
                                    ${"<%="} event.attributes.startTime ${"%>"}
                                ${"<%"} } ${"%>"}
                            </span>
                            
                            <h3 class="upcal-event-title"><a href="javascript:;">
                                ${"<%="} event.attributes.summary ${"%>"}
                            </a></h3>
                    </div>
                ${"<%"} }); ${"%>"}
            </div>
        ${"<%"} }); ${"%>"}
        </div>
    ${"<%"} } ${"%>"}
    
</script>

<script type="text/template" id="event-detail-template">
    <!-- Event title -->
    <h2>${"<%="} event.summary ${"%>"}</h2>

    <!-- Event time -->
    <div class="event-detail-date">
        <h3>Date:</h3>
        <p>
            ${"<%"} if (event.multiDay) { ${"%>"}
                ${"<%="} event.startTime ${"%>"} ${"<%="} event.startDate ${"%>"} - ${"<%="} event.endTime ${"%>"} ${"<%="} event.endDate ${"%>"}
            ${"<%"} } else if (event.allDay) { ${"%>"}
                All Day ${"<%="} event.startDate ${"%>"}
            ${"<%"} } else if (event.endTime && (event.endTime != event.startTime || event.startDate  != event.endDate ) ) { ${"%>"}
                ${"<%="} event.startTime ${"%>"} ${"<%="} event.endTime ${"%>"} ${"<%="} event.startDate ${"%>"}
            ${"<%"} } else { ${"%>"}
                ${"<%="} event.startTime ${"%>"} ${"<%="} event.startDate ${"%>"}
            ${"<%"} } ${"%>"}
        
        </p>
    </div>
    
    ${"<%"} if (event.location) { ${"%>"}
        <div>
            <h3>Location:</h3>
            <p>${"<%="} event.location ${"%>"}</p>
        </div>
    ${"<%"} } ${"%>"}

    ${"<%"} if (event.description) { ${"%>"}
        <div>
            <h3>Description:</h3>
            <p>${"<%="} event.description ${"%>"}</p>
        </div>
    ${"<%"} } ${"%>"}

    ${"<%"} if (event.link) { ${"%>"}
        <div>
            <h3>Link:</h3>
            <p>
                <a href="${"<%="} event.link ${"%>"}" target="_blank">${"<%="} event.link ${"%>"}</a>
            </p>
        </div>
    ${"<%"} } ${"%>"}
    
</script>

<script type="text/javascript"><rs:compressJs>
    ${n}.jQuery(function() {
        var $ = ${n}.jQuery;
        var _ = ${n}._;
        var Backbone = ${n}.Backbone;
        var upcal = ${n}.upcal;
        
        var ListView = upcal.EventListView.extend({
            el: "#${n}container .upcal-event-view",
            template: _.template($("#event-list-template").html())
        });

        var DetailView = upcal.EventDetailView.extend({
            el: "#${n}container .upcal-event-details",
            template: _.template($("#event-detail-template").html())
        });
        
        var view = new upcal.CalendarView({
            container: "#${n}container",
            listView: new ListView(),
            detailView: new DetailView(),
            eventsUrl: '<portlet:resourceURL id="START_DAYS_ETAG"/>', 
            startDate: '<fmt:formatDate value="${model.startDate}" type="date" pattern="MM/dd/yyyy" timeZone="${ model.timezone }"/>', 
            days: "${ model.days }"
        });
        
        $("#${n}container .upcal-range-day a").click(function () {
        	var link, days;
        	
        	link = $(this);
        	days = link.attr("days");
        	
        	$("#${n}container .upcal-range-day a").removeClass("selected-range");
        	link.addClass("selected-range");
        	
        	view.set("days", $(this).attr("days"));
        	view.getEvents();
        });

        $("#${n}container .upcal-range-datepicker a").click(function(event){
            var show = $(event.target).attr("show");
            showDatePicker(show);
            $.ajax({
                url: show == "true" ? "${showDatePickerURL}" : "${hideDatePickerURL}",
                success: function (data) {
                }
            });
        });

        var showDatePicker = function(show) {
            if(show == "true") {
                $('#${n}container .upcal-inline-calendar').show();
                $('#${n}showDatePicker').addClass('selected-range');
                $('#${n}hideDatePicker').removeClass('selected-range');
            } else {
                $('#${n}container .upcal-inline-calendar').hide();
                $('#${n}hideDatePicker').addClass('selected-range');
                $('#${n}showDatePicker').removeClass('selected-range');
            }
        };

        showDatePicker("${model.showDatePicker}");
        view.getEvents();
    });
</rs:compressJs></script>