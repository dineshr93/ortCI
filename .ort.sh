if [[ $1 == *"r"* ]]; then
    ort report --ort-file=.ort/evaluation-result.yml --output-dir=. --report-formats="PlainTextTemplate,SpdxDocument"
    #"CtrlXAutomation,CycloneDx,DocBookTemplate,EvaluatedModel,FossId,FossIdSnippet,GitLabLicenseModel,HtmlTemplate,ManPageTemplate,Opossum,PdfTemplate,PlainTextTemplate,SpdxDocument,StaticHtml,TrustSource,WebApp"
    if [ -d ".ort" ]; then
        echo "Stage 0: Clean previous .ort folder"
        rm -rf .ort
    fi
else
    if [ -d "report" ]; then
        echo "Stage 0: Clean previous report folder"
        rm -rf report
    fi
    if [ -d ".ort" ]; then
        echo "Stage 0: Clean previous .ort folder"
        rm -rf .ort
    fi
    echo "Stage 1: ORT Analyze"
    ort analyze --input-dir=. --output-dir=.ort
    echo "Stage 2: ORT Scan"
    ort scan --ort-file=.ort/analyzer-result.yml --output-dir=.ort
    echo "Stage 3: ORT Advise"
    ort advise --output-dir=.ort --ort-file=.ort/scan-result.yml --advisors="OSV"
    echo "Stage 4: ORT Evaluate"
    ort evaluate --ort-file=.ort/advisor-result.yml --output-dir=.ort
    echo "Stage 5: ORT Report"
    ort report --ort-file=.ort/evaluation-result.yml --output-dir=.ort --report-formats="WebApp"
fi
