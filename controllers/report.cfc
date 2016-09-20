<cfcomponent accessors="true">
   <cfproperty  
    name="purchase_orderService" 
     />
<cfscript>
    public function init(required any fw){
        variables.fw = arguments.fw;
        return this;
    }
    
</cfscript>
 
<cffunction
    name="exportReport"
    access="public"
    returntype="string"
    output="false"
    >
        <cfargument
            name="data"
            type="struct"
            required="false"
            default=""
            />
        <cfset filename=data.inspection_no&".pdf"/>
        <cfsetting enablecfoutputonly="true">
<!---         <cfcontent type="application/pdf" variable="objpdf">
        <cfheader name="Content-Disposition" value="attachment;filename=test.pdf"> --->
        <cfdocument format="PDF" localurl="no" overwrite="true" filename="#expandPath('/fileUpload/inspectionReport/')##filename#"
            marginTop="1" marginLeft=".35" marginRight=".35" marginBottom="1" 
            pageType="custom" pageWidth="8.5" pageHeight="10.2">
        <cfoutput><?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE html>
                <!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
                <!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
                <!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
                <!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
                <head>
                    <style>
                        body {
                            font-family: "Arial Narrow", Arial, sans-serif;
                            font-size: 11px;
                            line-height: 1.1;
                            color: ##000;
                        }
                        h4.title {
                            text-transform: uppercase;
                            margin: 0px;
                            font-size: 14px;
                        }
                        .col-1, .col-2, .col-3 {
                            vertical-align: top;
                        }
                        .order-info th, .inspection-info th, .result th, .seal-from th, .seal-to th{
                            text-align: right;
                        }
                        table, th, td {
                            vertical-align: top;
                        } 
                        table.table-result-report td.col-1 {
                            width: 50%;
                            float: left;
                        }
                        table.table-result-report td.col-2 {
                            width: 25%;
                            float: left;
                        }
                        table.table-result-report td.col-3 {
                            width: 25%;
                            float: left;
                        }
                        table.table-report {
                            border-collapse: collapse;
                        }
                        table.table-report, table.table-report th, table.table-report td {
                            border: 1px solid black;
                            padding: 2px
                        }
                        .accepted {
                            color: ##FE2EC8;
                        }
                        .report-title {
                            width: 85%;
                            float: left;
                            text-align: center;
                        }
                        .report-logo {
                            width: 14%;
                            float: left;
                            text-align: right;
                            vertical-align: middle;
                        }
                        .report-title h2 {
                            text-transform: uppercase;
                            text-align: center;
                            margin: 0px;
                        }
                        .center {
                            text-align: center;
                        }
                    </style>
                </head>
                <body>
                    <table class="table-result-report" style="width:100%">
                        <tr>
                            <td class="report-title">
                                <h3 style="padding:0; margin:0">
                                    INSPECTION REPORT
                                </h3>
                                <h3 style="padding:0; margin:0">
                                    --------
                                </h3>
                            </td>
                            <td class="report-logo">
                                <img style="width: 50px" src="/assets/img/logo/zwilling.png">
                            </td>
                        </tr>
                    </table>
                    <table class="basic_data" style="width:100%;">
                        <tr>
                            <td class="col-1">
                                <table class="customer">
                                    <tr>
                                        <td colspan="2" style="text-align:left"><h4 class="title">Customer:</h4></td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                        <td>#data.company.customer_name#</td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                        <td>#data.company.location_cus#</td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                        <td>#data.company.customer_address#</td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                        <td>#data.company.customer_phone#</td>
                                    </tr>
                                    
                                    <tr>
                                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                        <td>#data.company.customer_mail#</td>
                                    </tr>
                                </table>
                                <table class="supplier">
                                    <tr>
                                        <td colspan="2"><h4 class="title">Supplier:</h4></td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                        <td>#data.company.supplier_name#</td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                        <td>#data.company.location_sup#</td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                        <td>#data.company.supplier_address#</td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                        <td>#data.company.supplier_phone#</td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                        <td>#data.company.supplier_mail#</td>
                                    </tr>
                                </table>
                            </td>
                            <td class="col-2">
                                <table class="order-info">
                                    <tr>
                                        <th>Order No:</th>
                                        <td>#data.company.order_no#</td>
                                    </tr>
                                    <tr>
                                        <th>Position No:</th>
                                        <td>#data.company.position_no#</td>
                                    </tr>
                                    <tr>
                                        <th>Product Item No:</th>
                                        <td>#data.product_item_no#</td>
                                    </tr>
                                    <tr>
                                        <th>Product Line:</th>
                                        <td>#data.product_line#</td>
                                    </tr>
                                    <tr>
                                        <th>Product Item Name:</th>
                                        <td>#data.product_item_name#</td>
                                    </tr>
                                    <tr>
                                        <th>ABs:</th>
                                        <td>0</td>
                                    </tr>
                                </table>
                            </td>
                            <td class="col-3">
                                <table class="inspection-info">
                                    <tr>
                                        <th>Inspection No:</th>
                                        <td>#data.inspection_no#</td>
                                    </tr>
                                    <tr>
                                        <th>Inspection Date:</th>
                                        <td>#DateFormat(data.inspection_date, "long")#</td>
                                    </tr>
                                    <tr>
                                        <th>Inspector:</th>
                                        <td>#data.company.first_name_inspector1&" "&data.company.last_name_inspector1&"-"&data.company.first_name_inspector2&" "&data.company.last_name_inspector2#</td>
                                    </tr>
                                    <tr>
                                        <th>Set quantity:</th>
                                        <td>#data.set_item_lot_size#</td>
                                    </tr>
                                    <tr>
                                        <th>Single item quantity:</th>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <th>Inspection Lot:</th>
                                        <td>#data.item_lot_size#</td>
                                    </tr>
                                    <tr>
                                        <th>Inspected Quantity:</th>
                                        <td>#data.inspected_quantity#</td>
                                    </tr>
                                    <tr>
                                        <th>Major Defects Allowed:</th>
                                        <td>#data.major_allow#</td>
                                    </tr>
                                    <tr>
                                        <th>Minor Defects Allowed:</th>
                                        <td>#data.minor_allow#</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <br>
                    <br>
                    <table class="table-report" style="width:100%">
                        <tr>
                            <th>Characteristic</th>
                            <th>Description</th>
                            <th>Code</th>
                            <th>Critical</th>
                            <th>Major</th>
                            <th>Minor</th>
                            <th>Notice</th>
                        </tr>
                        <cfloop array="#data.report_mistakes#" index="row"> 
                            <tr>
                                <td>#row.characteristic#</td>
                                <td>#row.mistake_description_english#</td>
                                <td>#row.mistake_code#</td>
                                <td class="center">#row.number_of_critical_defect#</td>
                                <td class="center">#row.number_of_major_defect#</td>
                                <td class="center">#row.number_of_minor_defect#</td>
                                <td class="center">#row.number_of_notice#</td>
                            </tr>
                        </cfloop>
                    </table>
                    <table class="table-result-report" style="width:100%">
                        <tr>
                            <td class="col-1">
                                <table class="result">
                                    <tr>
                                        <th>Result:</th>
                                        <td><span class="accepted">#data.result#</span></td>
                                    </tr>
                                    <tr>
                                        <th>Inspected Carton Box Nr.:</th>
                                        <td>#data.carton_info#</td>
                                    </tr>
                                    <tr>
                                        <th>Comment</th>
                                        <td>#data.comment#</td>
                                    </tr>
                                </table>
                            </td>
                            <td class="col-2">
                                <table class="seal-from">
                                    <tr>
                                        <th>Seal From:</th>
                                        <cfif data.sealfrom1 != "" && data.sealfrom2 != "">
                                            <td>#data.sealfrom1&", "&data.sealfrom2#</td>
                                        <cfelse>
                                            <td>#data.sealfrom1&data.sealfrom2#</td>
                                        </cfif>
                                    </tr>
                                </table>
                            </td>
                            <td class="col-3">
                                <table class="seal-to">
                                    <tr>
                                        <th>To:</th>
                                        <cfif data.sealto1 != "" && data.sealto2 != "">
                                            <td>#data.sealto1&", "&data.sealto2#</td>
                                        <cfelse>
                                            <td>#data.sealto1&data.sealto2#</td>
                                        </cfif>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <br>
                    <br>
                    <br>
                    <p style="clear: both">#DateFormat(now(), "long") &" "&TimeFormat(now(), "h:mm tt")#</p>
                </body>
            </html></cfoutput>
        </cfdocument>
        <!--- <cfheader name="Content-Disposition" value="attachment;filename=file.pdf">
    <cfcontent type="application/pdf" file="#expandPath('.')#\file.pdf" deletefile="Yes"> --->

  <!---   <cffile action = "readBinary" file = "C:\inetpub\wwwroot\cfdocs\getting_started\photos\somewhere.jpg" variable = "aBinaryObj">  --->
     
    <!--- Output binary object to JPEG format for viewing. ---> 
<!---     <cffile action="write" file = "#expandPath('/fileUpload/inspectionReport/xuanlv.pdf')#"  
        output = "#toBinary(objpdf)#">  --->
    
    <cfreturn "success" />
</cffunction>
</cfcomponent>