 /*
 Copyright 2010 Erwan Jegouzo
 Licensed under the Apache License, Version 2.0 (the "License"); 
 you may not use this file except in compliance with the License. 
 You may obtain a copy of the License at 
 http://www.apache.org/licenses/LICENSE-2.0 
 Unless required by applicable law or agreed to in writing, software 
 distributed under the License is distributed on an "AS IS" BASIS, 
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
 See the License for the specific language governing permissions and 
 limitations under the License. 
 */
 package com.press2flash.events
{
	import flash.events.Event;
	
	/**
	 * Events triggered by ServerConnection when dealing with XML
	 * @author Erwan J�gouzo
	 */
	public class ServerEvent extends Event
	{
		
		public static const COMPLETE	:String = 'complete';
		public static const ERROR		:String = 'error';
		
		public var data			:XML;
		public var name			:String;
		public var XMLText		:Boolean;
		
		public function ServerEvent(type:String, data:XML, XMLText:Boolean = true)
		{
			this.XMLText 	= XMLText;
			this.name 		= name;
			this.data 		= data;
			super(type);
        }

		override public function clone():Event 
		{
			return new ServerEvent(type, data, XMLText);
		}
	}
}