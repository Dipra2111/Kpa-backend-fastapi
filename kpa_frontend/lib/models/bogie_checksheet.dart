class BogieChecksheetIn {
  final String? formNo;
  final String? submittedBy;
  final Map<String, dynamic> data;

  BogieChecksheetIn({this.formNo, this.submittedBy, required this.data});

  Map<String, dynamic> toJson() => {
        'form_no': formNo,
        'submitted_by': submittedBy,
        'data': data,
      }..removeWhere((key, value) => value == null);
}
