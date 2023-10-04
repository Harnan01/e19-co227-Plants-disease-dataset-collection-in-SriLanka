package com.CO227.FloraCare_Spring.disease;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
@CrossOrigin("http://localhost:65082")
public class DiseaseController {

    @Autowired
    private DiseaseService diseaseService;

    @GetMapping("/findDiseaseByName")
    public ResponseEntity<?> findDiseaseByName(@RequestParam("name") String name) {

        if (name == null || name.isEmpty()) {
            String messsage = "Invalid disease name.";
            System.out.println(messsage);
            return ResponseEntity.badRequest().body(messsage);
        }

        Disease disease = diseaseService.findDiseaseByName(name);


        if (disease != null) {
            Map<String, Object> response = new HashMap<>();
            response.put("id", disease.getId());
            response.put("diseaseName", disease.getDiseaseName());
            response.put("solution", disease.getSolution());
            response.put("image", disease.getImage());
            //response.put("predictedLabel", predictedLabel);
            return ResponseEntity.ok(response);
        } else {
            String messsage = "We couldn't find the disease";
            System.out.println(messsage);
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping("/diseaseName")
    public ResponseEntity<?> updateDiseaseLabel(@RequestBody Map<String, Object> result) {
        // Handle the received result label here
        Double probabilityPercentage = (Double) result.get("probability_percentage");

        return ResponseEntity.ok("Result label received successfully");
    }


}
