namespace Boo.MonoDevelop.Util.Completion

import System
import System.Collections.Generic

import MonoDevelop.Ide
import MonoDevelop.Ide.Gui
import MonoDevelop.Ide.Gui.Content
import MonoDevelop.Components
import MonoDevelop.Projects.Dom
import MonoDevelop.Projects.Dom.Output

class DataProvider(DropDownBoxListWindow.IListDataProvider):
	public IconCount as int:
		get:
			return _memberList.Count
		
	private _tag as object
	private _ambience as Ambience
	private _memberList as List of IMember
	private _document as Document
		
	def constructor(document as Document, tag as object, ambience as Ambience):
		_memberList = List of IMember()
		_document = document
		_tag = (tag as INode).Parent
		_ambience = ambience
		Reset()
		
	def Reset():
		_memberList.Clear()
		if(_tag isa ICompilationUnit):
			types = Stack of IType((_tag as ICompilationUnit).Types)
			while(types.Count > 0):
				type = types.Pop()
				_memberList.Add(type)
				for innerType in type.InnerTypes:
					types.Push(innerType)
		elif(_tag isa IType):
			_memberList.AddRange((_tag as IType).Members)
		_memberList.Sort({x,y|string.Compare(GetString(_ambience,x), GetString(_ambience,y), StringComparison.OrdinalIgnoreCase)})
		
	def GetString(ambience as Ambience, member as IMember):
		flags = OutputFlags.IncludeGenerics | OutputFlags.IncludeParameters | OutputFlags.ReformatDelegates
		if(_tag isa ICompilationUnit):
			flags |= OutputFlags.UseFullInnerTypeName
		return ambience.GetString(member, flags)
		
	def GetText(index as int) as string:
		return GetString (_ambience, _memberList[index])
		
	def GetMarkup(index as int) as string:
		return GetText (index)
		
	def GetIcon(index as int) as Gdk.Pixbuf:
		return ImageService.GetPixbuf(_memberList[index].StockIcon, Gtk.IconSize.Menu)
		
	def GetTag(index as int) as object:
		return _memberList[index]
		
	def ActivateItem(index as int):
		location = _memberList[index].Location
		extEditor = _document.GetContent of IExtensibleTextEditor()
		if(extEditor != null):
			extEditor.SetCaretTo(Math.Max(1, location.Line), location.Column)
			

