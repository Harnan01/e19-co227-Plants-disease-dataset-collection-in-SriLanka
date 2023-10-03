package com.CO227.FloraCare_Spring.disease;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
@CrossOrigin("http://192.168.8.155:65082")
public class DiseaseController {

    @Autowired
    private DiseaseService diseaseService;
    private  String predictedLabel;

    @GetMapping("/findDiseaseByName")
    public ResponseEntity<?> findDiseaseByName(String name) {

        name = predictedLabel;
        Disease disease = diseaseService.findDiseaseByName(name);

        if (disease != null) {
            return ResponseEntity.ok(disease);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping("/diseaseName")
    public ResponseEntity<?> updateDiseaseLabel(@RequestBody Map<String, Object> result) {
        // Handle the received result label here
        predictedLabel = (String) result.get("prediction");
        Double probabilityPercentage = (Double) result.get("probability_percentage");

        return ResponseEntity.ok("Result label received successfully");
    }


}
