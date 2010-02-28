﻿ /* Copyright 2010 Erwan Jegouzo Licensed under the Apache License, Version 2.0 (the "License");  you may not use this file except in compliance with the License.  You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software  distributed under the License is distributed on an "AS IS" BASIS,  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the License for the specific language governing permissions and  limitations under the License.  */ package com.press2flash.net{	import flash.events.EventDispatcher;	import flash.events.Event;	import flash.events.IOErrorEvent;	import flash.events.SecurityErrorEvent;	import flash.net.URLLoader;	import flash.net.URLRequest;	import flash.net.URLRequestMethod;	import flash.display.MovieClip;		import com.press2flash.data.WPConfig;	import com.press2flash.events.ServerEvent;			/**	 * This class takes care of sending and receiving the information 	 * between the flash Application and Wordpress API	 * @author Erwan Jégouzo	 */	public class ServerConnection 	{				/** relative path to the request.php file */		private var requestPath				:String 			= './../../../plugins/press2flash/request.php';		/** relative path to the upload.php file */		public static var UPLOAD_PATH		:String 			= './../../../plugins/press2flash/upload.php';				/** @private */		private var _dispatcher				:EventDispatcher = new EventDispatcher();				/** Debug mode */		public static var debugMode			:Boolean = false;				/** Specifies if the text content inserted in the wordpress post content has to be converted in a XML format */		private var _xmlOutput				:Boolean = true;				public function ServerConnection()		{			XML.prototype.ignoreWhite = true;		}			/**		 * Send the request in a XML format to query Wordpress API		 * @param	request the XML request		 */		public function send(request:XML):void		{				var urlRequest:URLRequest = new URLRequest(WPConfig.APP_PATH+requestPath);			urlRequest.contentType 	= "text/xml";			urlRequest.data 		= request;			urlRequest.method 		= URLRequestMethod.POST;						var urlLoader:URLLoader = new URLLoader();					urlLoader.addEventListener(Event.COMPLETE, onComplete);	        urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);	        urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);							if(debugMode) trace(request)		    urlLoader.load(urlRequest);		}			private function onComplete(event:Event):void 	    {	        var urlLoader:URLLoader = URLLoader(event.target);	        var xml:XML;        	        try			{	        	xml = new XML(urlLoader.data);				if(debugMode) trace("[ServerConnection.as] "+urlLoader.data)	        }			catch (error:Error)			{				xml = <response status="FAIL" desc="Invalid XML"/>				_dispatcher.dispatchEvent(new ServerEvent(ServerEvent.ERROR, xml, _xmlOutput));	        }                	        if(xml.@status == 'FAIL')	        {	        	_dispatcher.dispatchEvent(new ServerEvent(ServerEvent.ERROR,xml, _xmlOutput));	        }	        else	        {	        	_dispatcher.dispatchEvent(new ServerEvent(ServerEvent.COMPLETE, xml, _xmlOutput));	        }	    }    		public function addEventListener(type:String, listener:Function):void 		{	        _dispatcher.addEventListener(type, listener, false, 0, false);	    }	    private function onSecurityError(event:Event):void 	    {	    	var xml:XML = <response status="FAIL" desc="CROSS DOMAIN SECURITY ERROR"/>			_dispatcher.dispatchEvent(new ServerEvent(ServerEvent.ERROR,xml,_xmlOutput));	    }	    private function onError(event:Event):void 	    {	    	var xml:XML = <response status="FAIL" desc="UNABLE TO CONNECT TO SERVER URL"/>			_dispatcher.dispatchEvent(new ServerEvent(ServerEvent.ERROR, xml, _xmlOutput));	    }				public function set xmlOutput(bool:Boolean):void { _xmlOutput = bool; }		public function get xmlOutput():Boolean { return _xmlOutput; }	}}