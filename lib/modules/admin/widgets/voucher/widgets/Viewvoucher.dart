import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '/consts/appColors.dart';

import 'package:google_fonts/google_fonts.dart';

class VoucherPdfView extends StatelessWidget {
  final Map<String, dynamic> viewSelectedVoucher;

  const VoucherPdfView({
    Key? key,
    required this.viewSelectedVoucher,
  }) : super(key: key);

  // Build the PDF
  Future<Uint8List> _buildPdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.robotoRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();
    final mediumFont = await PdfGoogleFonts.robotoMedium();

    // Colors
    const headerColor = PdfColor.fromInt(0xFF000000); 
    const accentColor = PdfColor.fromInt(0xFFE65100); 
    const textColor = PdfColor.fromInt(0xFF212121); 
    const lightTextColor = PdfColor.fromInt(0xFF757575); 
    const sectionColor = PdfColor.fromInt(0xFFF5F5F5); 

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // HEADER
              pw.Center(
                child: pw.Text(
                  "Voucher Ticket",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: accentColor,
                    font: boldFont,
                  ),
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Center(
                child: pw.Text(
                  viewSelectedVoucher['vendorBusinessName'] ??
                      "GreenLeaf Organics",
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: headerColor,
                    font: boldFont,
                  ),
                ),
              ),
              pw.SizedBox(height: 14),

              // Voucher Info
              pw.Center(
                child: pw.Text(
                  "Voucher Number: ${viewSelectedVoucher['code'] ?? 'ACM'}   |   "
                  "Vendor Code: ${viewSelectedVoucher['vendorCode'] ?? 'EUR-BKN475-2025'}   |   "
                  "Date: ${viewSelectedVoucher['date'] ?? '5/8/2025'}",
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: lightTextColor,
                    font: font,
                  ),
                ),
              ),
              pw.SizedBox(height: 14),
              pw.Divider(thickness: 1, color: PdfColors.grey400),
              pw.SizedBox(height: 20),

              // Greeting
              pw.Text(
                "Hey ${viewSelectedVoucher['customer'] ?? 'Priya Patel'},",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: headerColor,
                  font: boldFont,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                "Thank you for choosing Connect India Enterprises! Here is your voucher ticket details:",
                style: pw.TextStyle(
                  fontSize: 10,
                  color: textColor,
                  font: font,
                ),
              ),
              pw.SizedBox(height: 20),

              // Amount
              pw.Text(
                "Amount: ₹${viewSelectedVoucher['amount'] ?? '5001.00'}/-",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: headerColor,
                  font: boldFont,
                ),
              ),
              pw.SizedBox(height: 12),

              // Validity
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Validity From: ${viewSelectedVoucher['validityFrom'] ?? '05/08/2025'}",
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: textColor,
                      font: font,
                    ),
                  ),
                  pw.Text(
                    "Validity To: ${viewSelectedVoucher['validityTo'] ?? '28/08/2025'}",
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: textColor,
                      font: font,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 18),
              pw.Text(
                "This voucher can be used for only ${viewSelectedVoucher['vendorBusinessName'] ?? 'GreenLeaf Organics'} within the validity period.",
                style: pw.TextStyle(
                  fontSize: 10,
                  color: lightTextColor,
                  font: font,
                ),
              ),
              pw.SizedBox(height: 20),

              // Vendor Details
              _sectionHeader("Vendor Details", sectionColor, boldFont),
              _detailsTable(
                [
                  {
                    "label": "Name:",
                    "value":
                        viewSelectedVoucher['vendor'] ?? "GreenLeaf Organics"
                  },
                  {
                    "label": "Email:",
                    "value":
                        viewSelectedVoucher['vendorEmail'] ?? "test@gmail.com"
                  },
                  {
                    "label": "Phone:",
                    "value":
                        viewSelectedVoucher['vendorMobileNo'] ?? "7896854789"
                  },
                  {
                    "label": "Address:",
                    "value": viewSelectedVoucher['vendorAddress'] ??
                        "R Worksquare Mp nagar zon e 2"
                  },
                  {
                    "label": "Pin code:",
                    "value": viewSelectedVoucher['vendorPincode'] ?? ""
                  },
                ],
                font,
                mediumFont,
              ),
              pw.SizedBox(height: 22),

              // Customer Details
              _sectionHeader("Customer Details", sectionColor, boldFont),
              _detailsTable(
                [
                  {
                    "label": "Name:",
                    "value": viewSelectedVoucher['customer'] ?? "Priya Patel"
                  },
                  {
                    "label": "Email:",
                    "value": viewSelectedVoucher['customerEmail'] ??
                        "priyapatel@gmail.com"
                  },
                  {
                    "label": "Phone:",
                    "value":
                        viewSelectedVoucher['customerPhone'] ?? "08651193833"
                  },
                  {
                    "label": "Address:",
                    "value": viewSelectedVoucher['customerAddress'] ??
                        "zone 2 plot 21 MP Nager B hopal"
                  },
                  {
                    "label": "Pin code:",
                    "value": viewSelectedVoucher['customerPincode'] ?? ""
                  },
                ],
                font,
                mediumFont,
              ),
              pw.SizedBox(height: 20),

              // Support Section
              pw.Center(
                child: pw.Text(
                  "Need help? Connect India Enterprises! is here for you!",
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: headerColor,
                    font: boldFont,
                  ),
                ),
              ),
              pw.SizedBox(height: 14),
              pw.Center(
                child: pw.Text(
                  "Support Features:",
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: textColor,
                    font: mediumFont,
                  ),
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Center(
                child: pw.Text(
                  "24x7 Support   •   Quick Resolution   •   Multilingual",
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: textColor,
                    font: font,
                  ),
                ),
              ),
              pw.SizedBox(height: 24),
              pw.Center(
                child: pw.Text(
                  "Visit us at http://connectindiaenterprises.com",
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: accentColor,
                    font: font,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Spacer(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Authorized Signatory",
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: headerColor,
                    font: boldFont,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _sectionHeader(String title, PdfColor bgColor, pw.Font boldFont) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: pw.BoxDecoration(
        color: bgColor,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.black,
          font: boldFont,
        ),
      ),
    );
  }

  pw.Widget _detailsTable(
      List<Map<String, String>> rows, pw.Font font, pw.Font mediumFont) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400, width: 1),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Table(
        columnWidths: {
          0: const pw.FlexColumnWidth(1.5),
          1: const pw.FlexColumnWidth(3),
        },
        children: [
          for (int i = 0; i < rows.length; i++)
            pw.TableRow(
              decoration: i % 2 == 0
                  ? pw.BoxDecoration(color: PdfColors.white)
                  : pw.BoxDecoration(color: PdfColor.fromInt(0xFFFAFAFA)),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(10),
                  child: pw.Text(
                    rows[i]['label']!,
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blueGrey900,
                      font: mediumFont,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(10),
                  child: pw.Text(
                    rows[i]['value']!,
                    style: pw.TextStyle(
                      fontSize: 11,
                      color: PdfColors.black,
                      font: font,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Voucher PDF",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.background,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              if (value == 'download') {
                final pdfBytes = await _buildPdf(PdfPageFormat.a4);
                await Printing.sharePdf(
                    bytes: pdfBytes, filename: 'voucher.pdf');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'download',
                child: Text('Download PDF'),
              ),
            ],
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) => _buildPdf(format),
        pdfFileName: 'voucher.pdf',
        canChangePageFormat: false,
        allowPrinting: false,
        loadingWidget: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
