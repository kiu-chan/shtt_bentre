import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giới thiệu'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Introduction section
              const Text(
                'Giới thiệu',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),
              _buildParagraph(
                '"Sở Hữu Trí Tuệ - Bến Tre" là một tổ chức chuyên trách trong việc bảo vệ và phát triển tài sản trí tuệ tại tỉnh Bến Tre. Được thành lập với mục tiêu hỗ trợ cá nhân, doanh nghiệp, và tổ chức trong việc đăng ký, quản lý, và khai thác các quyền sở hữu trí tuệ, đơn vị này đóng vai trò quan trọng trong việc thúc đẩy đổi mới sáng tạo và phát triển kinh tế địa phương.',
              ),
              const SizedBox(height: 12),
              _buildParagraph(
                'Sở Hữu Trí Tuệ Bến Tre không chỉ là một cơ quan quản lý mà còn là một đối tác chiến lược trong việc thúc đẩy sự phát triển của nền kinh tế địa phương. Thông qua việc bảo vệ và phát triển tài sản trí tuệ, tổ chức này đóng góp vào việc nâng cao giá trị của các sản phẩm và dịch vụ mang thương hiệu Bến Tre, từ đó tạo ra lợi thế cạnh tranh bền vững cho các doanh nghiệp địa phương trên thị trường trong nước và quốc tế.',
              ),
              const SizedBox(height: 12),
              _buildParagraph(
                'Sở Hữu Trí Tuệ Bến Tre là một nhân tố quan trọng trong việc bảo vệ và phát triển tài sản trí tuệ tại tỉnh nhà. Với vai trò hỗ trợ pháp lý, tư vấn, và nâng cao nhận thức về sở hữu trí tuệ, tổ chức này đang góp phần không nhỏ vào sự phát triển kinh tế và đổi mới sáng tạo tại Bến Tre. Sự hiện diện của Sở Hữu Trí Tuệ Bến Tre khẳng định cam kết của tỉnh trong việc bảo vệ và phát huy các giá trị sáng tạo, góp phần xây dựng một môi trường kinh doanh bền vững và thịnh vượng.',
              ),
              
              // Roles and Functions section
              const SizedBox(height: 24),
              const Text(
                'Vai Trò và Chức Năng',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),
              
              // Function items
              _buildFunctionItem(
                'Bảo vệ quyền sở hữu trí tuệ',
                'Sở Hữu Trí Tuệ Bến Tre giúp đảm bảo rằng các tài sản trí tuệ, bao gồm nhãn hiệu, sáng chế, kiểu dáng công nghiệp, và bản quyền, đều được bảo vệ hợp pháp. Tổ chức này hỗ trợ các thủ tục pháp lý cần thiết để đăng ký và bảo vệ quyền lợi của các chủ sở hữu tại địa phương.',
              ),
              _buildFunctionItem(
                'Tư vấn và hỗ trợ pháp lý',
                'Đơn vị cung cấp các dịch vụ tư vấn chuyên nghiệp liên quan đến luật sở hữu trí tuệ, giúp cá nhân và doanh nghiệp hiểu rõ về quyền và nghĩa vụ của mình, từ đó bảo vệ tốt hơn những sáng tạo và sản phẩm trí tuệ của họ.',
              ),
              _buildFunctionItem(
                'Nâng cao nhận thức',
                'Sở Hữu Trí Tuệ Bến Tre thường xuyên tổ chức các chương trình đào tạo, hội thảo và sự kiện nhằm nâng cao nhận thức của cộng đồng về tầm quan trọng của sở hữu trí tuệ. Những hoạt động này giúp người dân địa phương, đặc biệt là các doanh nghiệp nhỏ và vừa, nhận thức rõ hơn về giá trị của tài sản trí tuệ trong việc phát triển kinh doanh và cạnh tranh trên thị trường.',
              ),
              _buildFunctionItem(
                'Hỗ trợ thương mại hóa tài sản trí tuệ',
                'Một trong những mục tiêu chính của Sở Hữu Trí Tuệ Bến Tre là giúp các chủ sở hữu trí tuệ tận dụng tối đa giá trị kinh tế của tài sản trí tuệ. Đơn vị này cung cấp các giải pháp để thương mại hóa, cấp phép, và chuyển nhượng các quyền sở hữu trí tuệ, từ đó giúp nâng cao hiệu quả kinh doanh và phát triển kinh tế của địa phương.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        height: 1.5,
        color: Colors.black87,
      ),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildFunctionItem(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
              fontSize: 15,
              height: 1.5,
              color: Colors.black87,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}