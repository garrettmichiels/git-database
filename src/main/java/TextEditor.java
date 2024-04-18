import java.awt.event.*;
import java.awt.BorderLayout;
import javax.swing.*;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;

public class TextEditor extends JFrame implements ActionListener {
    
        private String text = "";
        private String title = "";
        private boolean saved = false;

        private final JTextArea textArea;
        private final JLabel languageTextField;
        private final JButton saveButton;
    
        public TextEditor() {
            setTitle("File Text Editor");
            setSize(400, 300);
            setDefaultCloseOperation(EXIT_ON_CLOSE);
            // setLocationRelativeTo(null);
    
            textArea = new JTextArea(10, 30);
            languageTextField = new JLabel("");
            saveButton = new JButton("Save");
            saveButton.addActionListener(this);
    
            JPanel panel = new JPanel(new BorderLayout());
            panel.add(new JScrollPane(textArea), BorderLayout.CENTER);
            panel.add(languageTextField, BorderLayout.NORTH);
            panel.add(saveButton, BorderLayout.SOUTH);
    
            add(panel);
        }

        public String getText() {
            return text;
        }

        public void setText(String textToSet) {
            text = textToSet;
            textArea.setText(textToSet);
        }

        public void setLanguageFile(String language, String filename) {
            title = filename + " - " + language;
            languageTextField.setText(title);
        }

        public boolean isSaved() {
            return saved;
        }

        @Override
        public void actionPerformed(ActionEvent e) {
            text = textArea.getText();
            saved = true;
        }

    }