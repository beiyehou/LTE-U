# V2.0 time 2014/09/24
@ ��Ҫ�޸� ������
�޸ĺ���    Send_packet()
�޸Ĺ���    �ĳ����ŵ�ΪĿ�����Ϊ�Խڵ�ΪĿ�����
�޸Ĵ���    Line 60 index = []; ���index

�޸ĺ���    Listen()
�޸Ĺ���    listen ��ͬʱ�ж������ʱ lisenQueue ���±�ֵֻ֧�ֵ���ֵ������
                    �ָ�Ϊ֧�ֶ��ֵ
@ ��Ҫ�޸�  �޻�
�޸ĺ���    Write_Result()
�޸Ĺ���    Ϊ�˺���д�� Write_Sturct �����໥��ϣ��ļ������ں����������

�޸ĺ���    Set_Packet()
�޸Ĵ���    Line 139 index = []; ���index

�¼Ӻ���    Write_Struct ()
��������    ֻ�����ڱ�ƽ̨ʵ�ֽṹ���ֶ����ļ���д��Ĳ���

@ ��Ҫ�޸ĵ�����
Dispatch_Stream()
�����ŵ� ��Ƶ ��Ƶ  Ŀǰ�Ƿֿ�ע�͵ģ�ϣ���ĳ����ַ�����ʾ�ķ��䷽ʽ������ COM_4_1 etc��
Compute_SNR()
�ú�������� SNR Ŀǰû�к� Set_Packet �е� Select_TBS ���Ӧ��
#V3.0 time 2014/9/30
@�޸ĺ���   Set_Packet()    Send_Packet()
@�޸Ĺ���   �����ǰbitת��Ϊʱ��Ƭ �����ۼ����� bug������һ�� packet_bit �ֶ��ݴ�packet_length 
                       ��Ӧ��bit����ÿ�μ����������� packet_bit �ۼ�ʵ�־�ȷ����
                      ��� total_date ��������Ϊ Gbit 10Mbit  bit ���������Ʒ�ʽ�洢���ݣ�ע���total_input
                        ������ total_input ���� Gbit  Mbit bit ���������Ʒ�ʽ�洢���ݵ�

@�޸ĺ���   Display_status()
@�޸Ĺ���   �޸���ͼ��ʾ total_date һά���� ����λ Kbit

@�޸ĺ���   Write_Struct()
@�޸Ĺ���   �������������У���ʾû�з���ȥͣ���� waitQueue �еİ�bit����packet_bit
                        ����bitƽ�� ��total_input = total_date + packet_bit + packet_receiver_bit + drop_bit (NOLBT ʱ��ײ�����İ�bit)