package com.yash.quizapplication.util;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import com.yash.quizapplication.domain.QuizQuestion;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ExcelReader {
    public static List<QuizQuestion> readQuestionsFromExcel(InputStream fileContent) {
        List<QuizQuestion> questionList = new ArrayList<>();
        try (Workbook workbook = new XSSFWorkbook(fileContent)) {
            Sheet sheet = workbook.getSheetAt(0); // Read first sheet
            Row headerRow = sheet.getRow(0); // Get the header row

            // Map column headers to indices
            Map<String, Integer> columnMap = getColumnMap(headerRow);

            // Iterate over data rows, skipping the header row
            for (int rowNum = 1; rowNum <= sheet.getLastRowNum(); rowNum++) {
                Row row = sheet.getRow(rowNum);
                if (row == null) continue; // Skip empty rows

                // Extract data from cells using column map
                String questionText = getCellValueAsString(row.getCell(columnMap.get("Questions")));
                String optionA = getCellValueAsString(row.getCell(columnMap.get("Option A")));
                String optionB = getCellValueAsString(row.getCell(columnMap.get("Option B")));
                String optionC = getCellValueAsString(row.getCell(columnMap.get("Option C")));
                String optionD = getCellValueAsString(row.getCell(columnMap.get("Option D")));
                String correctOption = getCellValueAsString(row.getCell(columnMap.get("Correct Option")));

                // Skip rows with empty question text
                if (questionText.trim().isEmpty()) {
                    continue;
                }

                QuizQuestion question = new QuizQuestion();
                question.setQuestionText(questionText.trim());
                question.setOptionA(optionA.trim());
                question.setOptionB(optionB.trim());
                question.setOptionC(optionC.trim());
                question.setOptionD(optionD.trim());
                question.setCorrectOption(correctOption.trim());

                questionList.add(question);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return questionList;
    }

    // Helper method to create a map of column headers to column indices
    private static Map<String, Integer> getColumnMap(Row headerRow) {
        Map<String, Integer> columnMap = new HashMap<>();
        for (int i = 0; i < headerRow.getLastCellNum(); i++) {
            Cell cell = headerRow.getCell(i);
            if (cell != null) {
                String columnHeader = getCellValueAsString(cell).trim();
                columnMap.put(columnHeader, i);
            }
        }
        return columnMap;
    }

    // Helper method to safely get cell value as string regardless of cell type
    private static String getCellValueAsString(Cell cell) {
        if (cell == null) {
            return "";
        }

        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue();
            case NUMERIC:
                // Check if it's a date
                if (DateUtil.isCellDateFormatted(cell)) {
                    return cell.getDateCellValue().toString();
                } else {
                    // Convert numeric value to string
                    double value = cell.getNumericCellValue();
                    // If the value is a whole number, remove the decimal part
                    if (value == Math.floor(value)) {
                        return String.valueOf((int)value);
                    }
                    return String.valueOf(value);
                }
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            case FORMULA:
                try {
                    return cell.getStringCellValue();
                } catch (Exception e) {
                    try {
                        return String.valueOf(cell.getNumericCellValue());
                    } catch (Exception ex) {
                        return "";
                    }
                }
            case BLANK:
                return "";
            default:
                return "";
        }
    }
}