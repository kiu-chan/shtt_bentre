import 'package:flutter/material.dart';

class TrademarkGuidePage extends StatefulWidget {
  const TrademarkGuidePage({super.key});

  @override
  State<TrademarkGuidePage> createState() => _TrademarkGuidePageState();
}

class _TrademarkGuidePageState extends State<TrademarkGuidePage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hướng dẫn nộp đơn Nhãn hiệu'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTabBar(),
            _buildSelectedContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTab('Khái niệm nhãn hiệu', 0),
          _buildTab('Thủ tục đăng ký nhãn hiệu', 1),
          _buildTab('Thủ tục sửa đổi, chuyển giao', 2),
          _buildTab('Thủ tục giải quyết khiếu nại NH', 3),
          _buildTab('Đăng ký quốc tế NH', 4),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _selectedTabIndex == index ? Colors.blue : Colors.grey.shade300,
              width: 2,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: _selectedTabIndex == index ? Colors.blue : Colors.grey[600],
            fontWeight: _selectedTabIndex == index ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildConceptContent();
      case 1:
        return _buildRegistrationContent();
      default:
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Nội dung đang được cập nhật...'),
        );
    }
  }

  Widget _buildConceptContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Khái niệm nhãn hiệu',
            'Nhãn hiệu là dấu hiệu dùng để phân biệt hàng hóa, dịch vụ của các tổ chức, cá nhân khác nhau.\n\n'
            'Dấu hiệu dùng làm nhãn hiệu phải là dấu hiệu nhìn thấy được dưới dạng chữ cái, từ ngữ, hình vẽ, hình ảnh, hình ba chiều hoặc sự kết hợp các yếu tố đó, được thể hiện bằng một hoặc nhiều màu sắc hoặc dấu hiệu âm thanh thể hiện được dưới dạng đồ họa.',
          ),
          _buildLawReference('[Điều 4.16, Điều 72 Luật Sở hữu trí tuệ]'),
          const SizedBox(height: 24),
          _buildSection(
            'Quyền đăng ký nhãn hiệu',
            'Theo Điều 87 Luật Sở hữu trí tuệ:',
          ),
          _buildRightsList(),
        ],
      ),
    );
  }

  Widget _buildRegistrationContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Yêu cầu về đơn đăng ký nhãn hiệu',
            'Đơn đăng ký nhãn hiệu phải bao gồm các tài liệu sau đây:',
          ),
          _buildDocumentsList(),
          const SizedBox(height: 24),
          _buildSection(
            'Yêu cầu về mẫu nhãn hiệu',
            'Mẫu nhãn hiệu phải đáp ứng các yêu cầu sau:',
          ),
          _buildRequirementsList(),
          const SizedBox(height: 24),
          _buildSection(
            'Quy trình đăng ký nhãn hiệu',
            'Quy trình đăng ký nhãn hiệu bao gồm các bước sau:',
          ),
          _buildProcessSteps(),
          const SizedBox(height: 24),
          _buildSection(
            'Phí và lệ phí',
            'Người nộp đơn phải nộp phí và lệ phí theo quy định:',
          ),
          _buildFeesList(),
        ],
      ),
    );
  }

  Widget _buildDocumentsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildListItem('1. Tờ khai đăng ký nhãn hiệu (theo mẫu)'),
        _buildListItem('2. Mẫu nhãn hiệu (kích thước không quá 80mm x 80mm và không nhỏ hơn 15mm x 15mm)'),
        _buildListItem('3. Bản mô tả nhãn hiệu'),
        _buildListItem('4. Bản liệt kê danh mục hàng hoá, dịch vụ mang nhãn hiệu'),
        _buildListItem('5. Giấy ủy quyền (nếu nộp đơn thông qua đại diện)'),
        _buildListItem('6. Các tài liệu chứng minh quyền đăng ký (nếu có)'),
        _buildListItem('7. Tài liệu chứng minh quyền ưu tiên (nếu có)'),
        _buildListItem('8. Chứng từ nộp phí, lệ phí'),
      ],
    );
  }

  Widget _buildRequirementsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildListItem('1. Thể hiện rõ các yếu tố cấu thành nhãn hiệu'),
        _buildListItem('2. Rõ ràng, sắc nét và có thể nhân bản được'),
        _buildListItem('3. Nếu có nhiều màu sắc thì phải nộp mẫu màu'),
        _buildListItem('4. Đối với nhãn hiệu ba chiều, mẫu phải thể hiện hình chiếu các mặt'),
        _buildListItem('5. Nếu nhãn hiệu có chữ không phải chữ Latin hoặc số không phải số Ả-rập thì phải phiên âm'),
      ],
    );
  }

  Widget _buildProcessSteps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildListItem('Bước 1: Chuẩn bị hồ sơ đơn đăng ký'),
        _buildListItem('Bước 2: Nộp đơn và phí, lệ phí'),
        _buildListItem('Bước 3: Thẩm định hình thức (trong thời hạn 1 tháng)'),
        _buildListItem('Bước 4: Công bố đơn (trong thời hạn 2 tháng kể từ ngày chấp nhận đơn hợp lệ)'),
        _buildListItem('Bước 5: Thẩm định nội dung (trong thời hạn 9 tháng)'),
        _buildListItem('Bước 6: Cấp văn bằng bảo hộ (nếu đáp ứng điều kiện)'),
      ],
    );
  }

  Widget _buildFeesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildListItem('1. Phí nộp đơn: 150.000 đồng'),
        _buildListItem('2. Phí công bố đơn: 120.000 đồng'),
        _buildListItem('3. Phí thẩm định nội dung: 550.000 đồng/nhóm'),
        _buildListItem('4. Phí tra cứu phục vụ thẩm định: 180.000 đồng/nhóm'),
        _buildListItem('5. Lệ phí cấp văn bằng bảo hộ: 120.000 đồng'),
        _buildNote('* Mức phí và lệ phí có thể thay đổi theo quy định hiện hành'),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 15,
            height: 1.5,
            color: Colors.black87,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildLawReference(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          height: 1.5,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildNote(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildRightsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRightItem(
          '1. Tổ chức, cá nhân có quyền đăng ký nhãn hiệu dùng cho hàng hóa do mình sản xuất hoặc dịch vụ do mình cung cấp.',
        ),
        _buildRightItem(
          '2. Tổ chức, cá nhân tiến hành hoạt động thương mại hợp pháp có quyền đăng ký nhãn hiệu cho sản phẩm mà mình đưa ra thị trường nhưng do người khác sản xuất với điều kiện người sản xuất không sử dụng nhãn hiệu đó cho sản phẩm và không phản đối việc đăng ký đó.',
        ),
        _buildRightItem(
          '3. Tổ chức tập thể được thành lập hợp pháp có quyền đăng ký nhãn hiệu tập thể để các thành viên của mình sử dụng theo quy chế sử dụng nhãn hiệu tập thể; đối với dấu hiệu chỉ nguồn gốc địa lý của hàng hóa, dịch vụ, tổ chức có quyền đăng ký là tổ chức tập thể của các tổ chức, cá nhân tiến hành sản xuất, kinh doanh tại địa phương đó; đối với địa danh, dấu hiệu khác chỉ nguồn gốc địa lý đặc sản địa phương của Việt Nam thì việc đăng ký phải được cơ quan nhà nước có thẩm quyền cho phép.',
        ),
        _buildRightItem(
          '4. Tổ chức có chức năng kiểm soát, chứng nhận chất lượng, đặc tính, nguồn gốc hoặc tiêu chí khác liên quan đến hàng hóa, dịch vụ có quyền đăng ký nhãn hiệu chứng nhận với điều kiện không tiến hành sản xuất, kinh doanh hàng hóa, dịch vụ đó.',
        ),
        _buildRightItem(
          '5. Hai hoặc nhiều tổ chức, cá nhân có quyền cùng đăng ký một nhãn hiệu để trở thành đồng chủ sở hữu với những điều kiện sau đây:',
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRightItem(
                'a) Việc sử dụng nhãn hiệu đó phải nhân danh tất cả các đồng chủ sở hữu hoặc sử dụng cho hàng hóa, dịch vụ mà tất cả các đồng chủ sở hữu đều tham gia vào quá trình sản xuất, kinh doanh;',
              ),
              _buildRightItem(
                'b) Việc sử dụng nhãn hiệu đó không gây nhầm lẫn cho người tiêu dùng về nguồn gốc của hàng hóa, dịch vụ.',
              ),
            ],
          ),
        ),
        _buildRightItem(
          '6. Người có quyền đăng ký quy định tại các khoản 1, 2, 3, 4 và 5 Điều này, kể cả người đã nộp đơn đăng ký có quyền chuyển giao quyền đăng ký cho tổ chức, cá nhân khác dưới hình thức hợp đồng bằng văn bản, để thừa kế hoặc kế thừa theo quy định của pháp luật với điều kiện các tổ chức, cá nhân được chuyển giao đáp ứng các điều kiện đối với những người có quyền đăng ký tương ứng.',
        ),
      ],
    );
  }

  Widget _buildRightItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          height: 1.5,
          color: Colors.black87,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }
}

class ProcessStep extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const ProcessStep({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.blue,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RequirementCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const RequirementCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.blue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DocumentTypeCard extends StatelessWidget {
  final String title;
  final List<String> requirements;
  final IconData icon;

  const DocumentTypeCard({
    super.key,
    required this.title,
    required this.requirements,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.blue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...requirements.map((req) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      req,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}

class FeeCard extends StatelessWidget {
  final String title;
  final String amount;
  final String description;

  const FeeCard({
    super.key,
    required this.title,
    required this.amount,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}