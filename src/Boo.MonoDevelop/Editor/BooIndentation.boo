
// Adapted from PythonEditorIndentation.cs
// Copyright (c) 2008 Christian Hergert <chris@dronelabs.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

namespace Boo.MonoDevelop.Editing

import System
import MonoDevelop.Ide.Gui.Content
import Gdk from "gdk-sharp"

class BooEditorIndentation(TextEditorExtension):

	override def KeyPress(key as Key, keyChar as char, modifier as ModifierType):
		if key != Gdk.Key.Return:
			return super(key, keyChar, modifier)
			
		lastLine = Editor.GetLineText(Editor.Caret.Line)
		if ShouldIndentAfter(lastLine):
			super(key, keyChar, modifier)
			Editor.InsertAtCaret ("\t")
			return false
		return super(key, keyChar, modifier)
		
	private def ShouldIndentAfter(line as string):
		trimmed = line.Trim()
		if trimmed.EndsWith(":"):
			return true
		if trimmed.StartsWith("if ") or trimmed.StartsWith("def "):
			openCount = line.Split(char('(')).Length
			closeCount = line.Split(char(')')).Length
			return openCount > closeCount
		return false