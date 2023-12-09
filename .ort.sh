SECONDS=0
if [[ $1 == "report" ]]; then
    if [ -d *"NOTICE_"* ]; then
        echo "=============== Stage 0: Clean previous report folder ==============="
        rm -rf *"NOTICE_"*
    fi
    if [ -d *"bom.spdx"* ]; then
        echo "=============== Stage 0: Clean previous report folder ==============="
        rm -rf *"bom.spdx"*
    fi
    ort report --ort-file=.ort/evaluation-result.yml --output-dir=. --report-formats="PlainTextTemplate,SpdxDocument" -O "PlainTextTemplate=template.id=NOTICE_SUMMARY"
    #"CtrlXAutomation,CycloneDx,DocBookTemplate,EvaluatedModel,FossId,FossIdSnippet,GitLabLicenseModel,HtmlTemplate,ManPageTemplate,Opossum,PdfTemplate,PlainTextTemplate,SpdxDocument,StaticHtml,TrustSource,WebApp"
else
    if [ -d "report" ]; then
        echo "=============== Stage 0: Clean previous report folder ==============="
        rm -rf report
    fi
    if [ -d ".ort" ]; then
        echo "=============== Stage 0: Clean previous .ort folder ==============="
        rm -rf .ort
    fi
    if [ -d *"NOTICE_"* ]; then
        echo "=============== Stage 0: Clean previous report folder ==============="
        rm -rf *"NOTICE_"*
    fi
    if [ -d *"bom.spdx"* ]; then
        echo "=============== Stage 0: Clean previous report folder ==============="
        rm -rf *"bom.spdx"*
    fi
    echo "=============== Stage 1: ORT Analyze ==============="
    ort analyze --input-dir=. --output-dir=.ort
    duration=$SECONDS
    echo "until ort analyze $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
    echo "=============== Stage 2: ORT Scan ==============="
    ort scan --ort-file=.ort/analyzer-result.yml --output-dir=.ort
    duration=$SECONDS
    echo "until ort scan $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
    echo "=============== Stage 3: ORT Advise ==============="
    ort advise --output-dir=.ort --ort-file=.ort/scan-result.yml --advisors="OSV"
    duration=$SECONDS
    echo "until ort advise $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
    echo "=============== Stage 4: ORT Evaluate ==============="
    ort evaluate --ort-file=.ort/advisor-result.yml --output-dir=.ort
    duration=$SECONDS
    echo "until ort evaluate $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
    echo "=============== Stage 5: ORT Report ==============="
    ort report --ort-file=.ort/evaluation-result.yml --output-dir=.ort --report-formats="WebApp"
    duration=$SECONDS
    echo "until ort report $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
    echo "Rectify the error present in .ort/webapp.html and run '.ort.sh report' to get final report"
fi
