namespace Boo.MonoDevelop.ProjectModel

import System
import System.IO

import MonoDevelop.Projects.Dom
import MonoDevelop.Projects.Dom.Parser

import Boo.Lang.Compiler

import Boo.MonoDevelop.Util

class BooParser(AbstractParser):
	
	_compiler = Boo.Lang.Compiler.BooCompiler()
	
	def constructor():
		# super("Boo", BooMimeType)
		super()
		pipeline = CompilerPipeline() { Steps.IntroduceModuleClasses() }
		_compiler.Parameters.Pipeline = pipeline
		
	override def CanParse(fileName as string):
		return Path.GetExtension(fileName).ToLower() == ".boo"
		
	override def Parse(dom as ProjectDom, fileName as string, content as string):
		document = ParsedDocument(fileName)
		if(null == document.CompilationUnit):
			document.CompilationUnit = CompilationUnit(fileName)
		if dom is null: return document
		
		try:
			index = ProjectIndexFactory.ForProject(dom.Project)
			assert index is not null
			module = index.Parse(fileName, content)
			IntroduceModuleClasses(module).Accept(DomConversionVisitor(document.CompilationUnit))
		except e:
			LogError e
		
		return document
		
	override def CreateResolver(dom as ProjectDom, editor, fileName as string):
		doc = cast(MonoDevelop.Ide.Gui.Document, editor)
		return BooResolver(dom, doc.CompilationUnit, fileName)
		
	private def IntroduceModuleClasses(module as Ast.Module):
		return _compiler.Run(Ast.CompileUnit(module.CloneNode())).CompileUnit
		
