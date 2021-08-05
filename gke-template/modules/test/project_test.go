package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/gcp"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestProjectModule(t *testing.T) {
	expectedName := fmt.Sprintf("test-%s", strings.ToLower(random.UniqueId()))

	opts := &terraform.Options{
		TerraformDir: "../project/examples",
		Vars: map[string]interface{}{
			"project_id": expectedName,
		},
	}

	defer terraform.Destroy(t, opts)
	_ = terraform.InitAndPlan(t, opts)
	_ = terraform.Apply(t, opts)
	got := terraform.OutputRequired(t, opts, "project_id")

	if got != expectedName {
		t.Errorf("got: %s want: %s ", got, expectedName)
	}

	_ = gcp.GetBuilds(t, expectedName)

}
