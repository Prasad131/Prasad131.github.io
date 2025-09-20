#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Configure the source folder and output file *)
src = NotebookDirectory[]<>"week9/";  (* or set to a path string *)
outSingle = FileNameJoin[{src, "All-Notebooks.pdf"}];

(* Find notebooks *)
nbs = FileNames["*.nb", src];

If[nbs === {},
  Print["No notebooks found."];
  Abort[]
];

(* Open notebooks headless, export each to PDF *)
pdfs = Reap[
   Do[
     nb = NotebookOpen[nbf, Visible -> False];
     pdf = FileNameJoin[{src, FileBaseName[nbf] <> ".pdf"}];
     NotebookPrint[nb, pdf];  (* uses front end to make paginated PDF *)
     NotebookClose[nb, Save -> False];
     Sow[pdf];
     ,
     {nbf, nbs}
   ]
][[2, 1]];  (* list of exported PDFs *)

(* Combine into one PDF *)
combined =
  Quiet@Check[
    (* Preferred: combine PDFs natively if available (v13.3+) *)
    NotebookCombine[pdfs, outSingle]; outSingle,
    $Failed
  ];

If[combined === $Failed,
  (* Fallback: create a single temporary notebook and print once *)
  tmp = CreateDocument[
    Flatten@Riffle[
      Import[#, "NB"] & /@ nbs,
      Cell[BoxData@ToBoxes@"", "PageBreak"] (* insert page breaks *)
    ],
    Visible -> False
  ];
  NotebookPrint[tmp, outSingle];
  NotebookClose[tmp, Save -> False];
];

Print["Wrote: ", outSingle];

