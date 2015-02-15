//
// $Id$
//

//
// Create ROOT style HTML documentation
//
// Use like:
// .x build/make_doc.C+("$SNS")
//
#include <TClassEdit.h>
#include <TClass.h>
#include <TClassTable.h>
#include <TError.h>
#include <THashList.h>
#include <THtml.h>
#include <TList.h>
#include <TNamed.h>
#include <TRegexp.h>
#include <TSystem.h>
#include <TDirectory.h>

void get_class_list(TList *cl)
{
   // start from begining
   gClassTable->Init();

   while(const char *cname = gClassTable->Next()) {
      cl->Add(new TNamed(cname,cname));
   }
}

void load_libs(TString topvar)
{
   TDirectory* prevdir = gDirectory;
   TRegexp re("*.so", true);
   void *dir = gSystem->OpenDirectory(
      gSystem->ExpandPathName(Form("%s/lib",topvar.Data())));
   if(!dir) return;
   while(const char *file = gSystem->GetDirEntry(dir)) {
      TString s(file);
      if (s.Index(re) == kNPOS)
         continue;
      ::Info("make_doc","Loading %s", file);
      gSystem->Load(file);
   }
   gSystem->FreeDirectory(dir);
   gDirectory = prevdir;
}

void make_doc(TString topvar)
{
   THashList  base;
   THtml html;

   // Get list of ROOT classes
   get_class_list(&base);

   // Load our libraries
   load_libs(topvar);
   
   html.SetProductName("SnowShovel");
   
   html.SetIncludePath(Form("%s/include:$ROOTSYS/include",topvar.Data()));
   html.SetRootURL("http://root.cern.ch/root/htmldoc/");
   html.SetHomepage("https://arianna.ps.uci.edu/");
   
   html.MakeAll();
}

