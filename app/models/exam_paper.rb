# encoding: utf-8
class ExamPaper < ActiveRecord::Base
  attr_accessible :name
  has_and_belongs_to_many :questions

  def to_latex
    result = %q{\documentclass[twocolumn]{exam}
\setlength{\columnseprule}{0.4pt} % 顯示兩欄中線
\everymath{\displaystyle} % 讓數學符號易於閱讀（例如分數）
\usepackage{graphicx}     % 啟用貼圖
\usepackage{xeCJK}        % 讓中英文字體分開設置
\setCJKmainfont{標楷體}   % 設定中文為系統上的字型，而英文不去更動，使用原TeX字型
%\usepackage{fontspec}    % 加這個就可以使用系統中的字型
%\printanswers            % 顯示解答
\begin{document}
\begin{questions}}
    result = questions.inject(result){|memo, question|
      memo + question.content + $/
    }
    result << %q{\end{questions}
\end{document}}
  end
end
