SECONDS=0
reportname=bill-of-materials
if [[ $1 == "report" ]]; then
    if [ -d $reportname ]; then
        echo "=============== Stage 0: Clean previous report folder ==============="
        rm -rf $reportname
    fi
    ort report --ort-file=.ort/evaluation-result.yml --output-dir=$reportname --report-formats="PlainTextTemplate,SpdxDocument" -O "PlainTextTemplate=template.id=NOTICE_SUMMARY"
    #"CtrlXAutomation,CycloneDx,DocBookTemplate,EvaluatedModel,FossId,FossIdSnippet,GitLabLicenseModel,HtmlTemplate,ManPageTemplate,Opossum,PdfTemplate,PlainTextTemplate,SpdxDocument,StaticHtml,TrustSource,WebApp"
else
    if [ -d $reportname ]; then
        echo "=============== Stage 0: Clean previous report folder ==============="
        rm -rf $reportname
    fi
    if [ -d ".ort" ]; then
        echo "=============== Stage 0: Clean previous .ort folder ==============="
        rm -rf .ort
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

    echo "==========================================================================================================="
    echo "| Rectify the error present in .ort/scan-report-web-app.html and run '.ort.sh report' to get final report |"
    echo "==========================================================================================================="

    if [ -f ".ort/scan-report-web-app.html" ]; then
        echo "=============== Opening .ort/scan-report-web-app.html ==============="
        open .ort/scan-report-web-app.html
    fi
fi
