namespace Boo.MonoDevelop.Util.Completion

import System
import System.Linq.Enumerable

import MonoDevelop.Ide
import MonoDevelop.Ide.Gui
import MonoDevelop.Ide.Gui.Content
import MonoDevelop.Components
import MonoDevelop.Projects.Dom

class CompilationUnitDataProvider(DropDownBoxListWindow.IListDataProvider):
	private _document as Document
	
	internal static Pixbuf as Gdk.Pixbuf:
		get:
			return ImageService.GetPixbuf(Gtk.Stock.Add, Gtk.IconSize.Menu)
		
	public IconCount:
		get:
			if(_document.ParsedDocument != null):
				return _document.ParsedDocument.UserRegions.Count()
			return 0
		
	def constructor(document as Document):
		_document = document
		
	def GetText(position as int) as string:
		return (WorkaroundElementAt(_document.ParsedDocument.UserRegions, position) as FoldingRegion).Name
		
	def GetIcon(position as int) as Gdk.Pixbuf:
		return Pixbuf
		
	def GetTag(position as int) as object:
		return WorkaroundElementAt(_document.ParsedDocument.UserRegions, (position))
		
	def ActivateItem(position as int):
		region = WorkaroundElementAt(_document.ParsedDocument.UserRegions, position) as FoldingRegion
		editor = _document.GetContent of IExtensibleTextEditor()
		if(editor != null):
			editor.SetCaretTo(Math.Max(1, region.Region.Start.Line), region.Region.Start.Column)
			
	def Reset():
		pass
		
	private def WorkaroundElementAt(items, index):
		i = 0
		for item in items:
			if(i == index):
				return item
			++i
		return null
			
	
